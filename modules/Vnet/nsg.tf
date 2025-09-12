resource "azurerm_network_security_group" "web_nsg" {
  name = "web_nsg"
  location = var.vnet_location
  resource_group_name = var.rg_name

  security_rule {
    name = "AllowSSH"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "Allow-HTTP"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "Allow-LB-Probe"
    priority = 120
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

   security_rule {
    name = "Allow-Internet-OutBound"
    priority = 130
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "Internet"
  }

  #   security_rule {
  #   name = "AllowRDP"
  #   priority = 110
  #   direction = "Inbound"
  #   access = "Allow"
  #   protocol = "Tcp"
  #   source_port_range = "*"
  #   destination_port_range = "3389"
  #   source_address_prefix = "*"
  #   destination_address_prefix = "*"
  # }

  #   security_rule {
  #   name = "DenyAllInBound"
  #   priority = 200
  #   direction = "Inbound"
  #   access = "Deny"
  #   protocol = "*"
  #   source_port_range = "*"
  #   destination_port_range = "*"
  #   source_address_prefix = "*"
  #   destination_address_prefix = "*"
  # }

  # security_rule {
  #   name = "DenyInternetOutBound"
  #   priority = 210
  #   direction = "Outbound"
  #   access = "Deny"
  #   protocol = "*"
  #   source_port_range = "*"
  #   destination_port_range = "*"
  #   source_address_prefix = "*"
  #   destination_address_prefix = "Internet"
  # }

  # security_rule {
  #   name = "AllowICMP"
  #   priority = 101
  #   direction = "Inbound"
  #   access = "Allow"
  #   protocol = "Icmp"
  #   source_port_range = "*"
  #   destination_port_range = "*"
  #   source_address_prefix = "*"
  #   destination_address_prefix = "*"
  # }
}

# resource "azurerm_network_security_group" "db_nsg" {
#   name = "db_nsg"
#   location = var.vnet_location
#   resource_group_name = var.rg_name

#   security_rule {
#     name = "DenyInternetOutBound"
#     priority = 200
#     direction = "Outbound"
#     access = "Deny"
#     protocol = "*"
#     source_port_range = "*"
#     destination_port_range = "*"
#     source_address_prefix = "*"
#     destination_address_prefix = "Internet"
#   }
# }

resource "azurerm_subnet_network_security_group_association" "webnsg_pubsubnet1" {
  network_security_group_id = azurerm_network_security_group.web_nsg.id
  subnet_id = azurerm_subnet.public_subnet_1.id
  depends_on = [ azurerm_network_security_group.web_nsg , azurerm_subnet.public_subnet_1 ]
}

resource "azurerm_subnet_network_security_group_association" "webnsg_pubsubnet2" {
  network_security_group_id = azurerm_network_security_group.web_nsg.id
  subnet_id = azurerm_subnet.public_subnet_2.id
  depends_on = [ azurerm_network_security_group.web_nsg , azurerm_subnet.public_subnet_2 ]
}

resource "azurerm_subnet_network_security_group_association" "webnsg_prisubnet1" {
  network_security_group_id = azurerm_network_security_group.web_nsg.id
  subnet_id = azurerm_subnet.private_subnet_1.id
  depends_on = [ azurerm_network_security_group.web_nsg , azurerm_subnet.private_subnet_1 ]
}

resource "azurerm_subnet_network_security_group_association" "webnsg_prisubnet2" {
  network_security_group_id = azurerm_network_security_group.web_nsg.id
  subnet_id = azurerm_subnet.private_subnet_2.id
  depends_on = [ azurerm_network_security_group.web_nsg , azurerm_subnet.private_subnet_2]
}

# resource "azurerm_subnet_network_security_group_association" "Prisubnet1_blkOB" {
#   network_security_group_id = azurerm_network_security_group.private_nsg.id
#   subnet_id = azurerm_subnet.private_subnet_1.id
#   depends_on = [ azurerm_network_security_group.private_nsg , azurerm_subnet.private_subnet_1 ]
# }

# resource "azurerm_subnet_network_security_group_association" "Prisubnet2_blkOB" {
#   network_security_group_id = azurerm_network_security_group.private_nsg.id
#   subnet_id = azurerm_subnet.private_subnet_2.id
#   depends_on = [ azurerm_network_security_group.private_nsg , azurerm_subnet.private_subnet_2 ]
# }