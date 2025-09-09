resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  resource_group_name = var.rg_name
  location = var.vnet_location
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "public_subnet_1" {
  name = "${var.vnet_name}-public_subnet-1"
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = [var.address_prefixes_public_subnet_1]
  depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_subnet" "public_subnet_2" {
  name = "${var.vnet_name}-public_subnet-2"
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = [var.address_prefixes_public_subnet_2]
  depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_subnet" "private_subnet_1" {
  name = "${var.vnet_name}-private_subnet-1"
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = [var.address_prefixes_private_subnet_1]
  depends_on = [ azurerm_virtual_network.vnet ]
}


resource "azurerm_subnet" "private_subnet_2" {
  name = "${var.vnet_name}-private_subnet-2"
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = [var.address_prefixes_private_subnet_2]
  depends_on = [ azurerm_virtual_network.vnet ]
}

# resource "azurerm_route_table" "public_rt" {
#   name = "${var.env}-publicRouteTable"
#   resource_group_name = var.rg_name
#   location = var.vnet_location
  
#   route {
#     name           = "toInternet"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "Internet"
#   }
# }

# resource "azurerm_route_table" "private_rt" {
#   name = "${var.env}-privateRouteTable"
#   resource_group_name = var.rg_name
#   location = var.vnet_location

#   route {
#     name = "viaNATGateway"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type = "VirtualAppliance"
#     next_hop_in_ip_address = azurerm_nat_gateway.nat_gateway.azurerm_public_ip
#   }
#   depends_on = [ azurerm_nat_gateway.nat_gateway ]
# }

resource "azurerm_public_ip" "pub_ip" {
  name = "publicIPForNAT"
  resource_group_name = var.rg_name
  location = var.vnet_location
  allocation_method = "Static"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name = "${var.env}-Nat_Gateway"
  resource_group_name = var.rg_name
  location = var.vnet_location
  sku_name = "Standard"
  idle_timeout_in_minutes = 10
  #zones = [1]
  depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip_accociate" {
  public_ip_address_id = azurerm_public_ip.pub_ip.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
  depends_on = [ azurerm_virtual_network.vnet , azurerm_nat_gateway.nat_gateway , azurerm_public_ip.pub_ip ]
}

resource "azurerm_subnet_nat_gateway_association" "subnet_natgateway_association1" {
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
  subnet_id = azurerm_subnet.private_subnet_1.id
  depends_on = [ azurerm_nat_gateway.nat_gateway , azurerm_subnet.private_subnet_1 ]
}

resource "azurerm_subnet_nat_gateway_association" "subnet_natgateway_association2" {
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
  subnet_id = azurerm_subnet.private_subnet_2.id
  depends_on = [ azurerm_nat_gateway.nat_gateway , azurerm_subnet.private_subnet_2 ]
}

# resource "azurerm_subnet_route_table_association" "subnet_route_asso_pu1" {
#   route_table_id = azurerm_route_table.public_rt.id
#   subnet_id = azurerm_subnet.public_subnet_1.id
# }
# resource "azurerm_subnet_route_table_association" "subnet_route_asso_pu2" {
#   route_table_id = azurerm_route_table.public_rt.id
#   subnet_id = azurerm_subnet.public_subnet_2.id
# }

# resource "azurerm_subnet_route_table_association" "subnet_route_asso_pr1" {
#   route_table_id = azurerm_route_table.private_rt.id
#   subnet_id = azurerm_subnet.private_subnet_1.id
# }
# resource "azurerm_subnet_route_table_association" "subnet_route_asso_pr2" {
#   route_table_id = azurerm_route_table.private_rt.id
#   subnet_id = azurerm_subnet.private_subnet_2.id
# }