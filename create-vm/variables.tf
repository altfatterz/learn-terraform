variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "hostname" {
  default     = "myVM"
  description = "Specifies the Hostname which should be used for this Virtual Machine."
}

variable "admin_username" {
  default     = "ubuntu"
  description = "The username of the local administrator used for the Virtual Machine."
}