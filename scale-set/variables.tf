variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "admin_username" {
  default     = "azureuser"
  description = "The username of the local administrator used for the Virtual Machine."
}

variable "nr_of_instances" {
  default = 1
  description = "The number of Virtual Machines in the Scale Set."
}

variable "sku" {
  default = "Standard_B1s"
  description = "The Virtual Machine SKU for the Scale Set, such as Standard_F2."
}