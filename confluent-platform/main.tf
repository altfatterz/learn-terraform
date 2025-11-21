resource "random_pet" "rg-name" {
  prefix = var.resource_group_name_prefix
}

resource "random_string" "fqdn" {
  length  = 8
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg-name.id
  location = var.resource_group_location
}

# Create (and display) an SSH key
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
