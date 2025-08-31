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
