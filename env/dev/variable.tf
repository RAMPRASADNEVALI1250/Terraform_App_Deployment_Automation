variable "env" {
  default = "dev"
}

variable "location" {
default = "centralindia"
}

variable "rg_name" {
    default = "Dev-RG"
}

variable "rg_location" {
default = "centralindia"
}

variable "vnet_name" {
  type = string
  description = "Virtual Network name"
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


