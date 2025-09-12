module "rg" {
  source = "../../modules/rg"
  rg_name = var.rg_name
  rg_location = var.rg_location
}

module "vnet" {
  source = "../../modules/Vnet"
  env = var.env
  vnet_name = var.vnet_name
  rg_name = var.rg_name
  vnet_location = var.vnet_location
  address_prefixes_private_subnet_1 = var.address_prefixes_private_subnet_1
  address_prefixes_private_subnet_2 = var.address_prefixes_private_subnet_2
  address_prefixes_public_subnet_1 = var.address_prefixes_public_subnet_1
  address_prefixes_public_subnet_2 = var.address_prefixes_public_subnet_2

  depends_on = [ module.rg ]
}

# module "vm" {
#   source = "../../modules/vm"
#   env = var.env
#   location = var.rg_location
#   rg_name = var.rg_name
#   private_subnet_id_1 = module.vnet.private_subnet1
#   public_subnet_id_1 = module.vnet.public_subnet_1
#   depends_on = [ module.vnet ]
# }

# module "bastion" {
#   source = "../../modules/bastion"
#   location = var.location
#   rg_name = var.rg_name
#   vnet_name = module.vnet.vnet_name
#   depends_on = [ module.rg ,module.vnet ]
# }

module "vmss" {
  source = "../../modules/azure-vmss"
  env = var.env
  location = var.location
  rg_name = var.rg_name
  private_subnet_id_2 = module.vnet.private_subnet2
  depends_on = [ module.vnet ]
}