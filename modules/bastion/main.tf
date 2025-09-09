resource "azurerm_bastion_host" "bastion" {
  name = "Bastion"
  location = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name = "config"
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
    subnet_id = azurerm_subnet.bastion_subnet.id
  }
  depends_on = [ azurerm_subnet.bastion_subnet , azurerm_public_ip.bastion_ip ]
}

resource "azurerm_subnet" "bastion_subnet" {
  name = "AzureBastionSubnet"
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = ["10.0.1.0/27"]
}

resource "azurerm_public_ip" "bastion_ip" {
  name = "Bastion_ip"
  location = var.location
  resource_group_name = var.rg_name
  allocation_method = "Static"
  sku = "Standard"
}