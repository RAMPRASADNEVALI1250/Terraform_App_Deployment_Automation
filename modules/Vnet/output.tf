output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "public_subnet_1"{
  value = azurerm_subnet.public_subnet_1.id
}

output "public_subnet_2"{
  value = azurerm_subnet.public_subnet_2.id
}

output "private_subnet1" {
  value = azurerm_subnet.private_subnet_1.id
}

output "private_subnet2" {
  value = azurerm_subnet.private_subnet_2.id
}
