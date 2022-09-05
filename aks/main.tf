resource "random_pet" "rg-name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg-name.id
  location = var.resource_group_location
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_cluster_name

  default_node_pool {
    name       = "default"
    node_count = var.aks_cluster_node_count
    vm_size    = "standard_d2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  azure_policy_enabled = false

  tags = {
    env = "dev"
  }

}
