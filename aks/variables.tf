variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default     = "swedencentral"
  description = "Location of the resource group."
}

variable "aks_cluster_name" {
  default     = "aks-cluster"
  description = "The name of the AKS cluster"
}

variable "aks_cluster_node_count" {
  default     = "2"
  description = "The AKS cluster node count"
}

variable "aks_cluster_node_type" {
  default     = "standard_d2_v2"
  description = "The AKS cluster node type"
}
