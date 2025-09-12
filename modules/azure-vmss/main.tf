resource "azurerm_storage_account" "main" {
  name                     = "${var.env}storagevmssramtest"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name = "${var.env}-vmss"
  resource_group_name = var.rg_name
  location = var.location
  sku = "Standard_F2"
  #instances          = 3
  admin_username     = "***"
  admin_password     = "***"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

    custom_data = base64encode(<<EOF
                                #!/bin/bash
                                sudo apt-get update
                                sudo apt-get install -y nginx
                                sudo chown AdminRam /var/www/html/index.html
                                P_IP=$(hostname -I | awk '{print $1}')
                                echo "<html><head><title>NGNIX VM</title></head><body><h1>Welcome to NGINX</h1><p>PrivateIP: $P_IP</p></body></html>" > /var/www/html/index.nginx-debian.html
                                sudo systemctl enable nginx
                                sudo systemctl start nginx
                                EOF
                                )

    network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.private_subnet_id_2
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backendPool.id]
      #load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.lb_nat_pool.id]
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

    # Since these can change via auto-scaling outside of Terraform,
  # let's ignore any changes to the number of instances
#   lifecycle {
#     ignore_changes = ["instances"]
#     }

    boot_diagnostics {
    storage_account_uri = azurerm_storage_account.main.primary_blob_endpoint
    }
    depends_on = [ azurerm_lb_probe.lb_probe ,azurerm_storage_account.main ]
}

resource "azurerm_monitor_autoscale_setting" "main" {
  name                = "autoscale-config"
  resource_group_name = var.rg_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {
    name = "AutoScale"

    capacity {
      default = 3
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}

resource "azurerm_public_ip" "lb_pip" {
  name                = "${var.env}-vmss-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  #domain_name_label   = var.rg_name 
}

resource "azurerm_lb" "lb" {
  name                = "${var.env}-vmss-lb"
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backendPool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "http-probe"
  protocol            = "Http"
  port                = 80
  request_path = "/"
  interval_in_seconds = 10
  number_of_probes = 2
}

resource "azurerm_lb_rule" "lb_rule" {
  name = "http-rule"
  loadbalancer_id = azurerm_lb.lb.id
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backendPool.id]
  probe_id = azurerm_lb_probe.lb_probe.id
}

# resource "azurerm_lb_nat_pool" "lb_nat_pool" {
#   resource_group_name            = var.rg_name
#   name                           = "ssh"
#   loadbalancer_id                = azurerm_lb.lb.id
#   protocol                       = "Tcp"
#   frontend_port_start            = 220
#   frontend_port_end              = 229
#   backend_port                   = 22
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

output "public_ip"{
  value = azurerm_public_ip.lb_pip.ip_address
}

