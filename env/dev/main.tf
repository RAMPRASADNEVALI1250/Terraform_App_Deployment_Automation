module "rg" {
  source = "../../modules/rg"
  rg_name = var.rg_name
  rg_location = var.rg_location
}

module "vnet" {
  source = "../../modules/Vnet"
  vnet_name = var.vnet_name
  rg_name = var.rg_name
  vnet_location = var.vnet_location
}