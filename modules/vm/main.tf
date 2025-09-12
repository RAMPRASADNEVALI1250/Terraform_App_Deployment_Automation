resource "azurerm_linux_virtual_machine" "vm1" {
  name = "${var.env}-vm-1"
  resource_group_name = var.rg_name
  location = var.location
  size = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.nic1.id]
  admin_username = "***"
  admin_password = "***"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = { "vm" = "drift" }

  depends_on = [ azurerm_network_interface.nic1 ]
}

resource "azurerm_linux_virtual_machine" "vm2" {
  name = "${var.env}-vm-2"
  resource_group_name = var.rg_name
  location = var.location
  size = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.nic2.id]
  admin_username = "***"
  admin_password = "***"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = { "vm" = "drift" }

  depends_on = [ azurerm_network_interface.nic2 ]
}

resource "azurerm_network_interface" "nic1" {
  name = "${var.env}-vm1"
  resource_group_name = var.rg_name
  location = var.location
  ip_configuration {
    name = "nic-config"
    subnet_id = var.private_subnet_id_1
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm_publicIP.id
  }
  depends_on = [ azurerm_public_ip.vm_publicIP ]
}

resource "azurerm_network_interface" "nic2" {
  name = "${var.env}-vm2"
  resource_group_name = var.rg_name
  location = var.location
  ip_configuration {
    name = "nic-config"
    subnet_id = var.public_subnet_id_1
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "vm_publicIP" {
  name = "${var.env}-vm1-PublicIP"
  resource_group_name = var.rg_name
  location = var.location
  allocation_method = "Static"
}