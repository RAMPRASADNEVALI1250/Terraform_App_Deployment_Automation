module "rg" {
  source = "../../modules/rg"
  rg_name = var.rg_name
  rg_location = var.rg_location
}