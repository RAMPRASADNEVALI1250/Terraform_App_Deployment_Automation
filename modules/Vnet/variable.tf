variable "env" {
  type = string
}
variable "vnet_name" {
  type = string
  description = "Virtual Network name"
}

variable "rg_name" {
  type = string
}

variable "vnet_location" {
  type = string
}

variable "address_prefixes_public_subnet_1" {
  type = string
}

variable "address_prefixes_public_subnet_2" {
  type = string
}

variable "address_prefixes_private_subnet_1" {
  type = string
}

variable "address_prefixes_private_subnet_2" {
  type = string
}
