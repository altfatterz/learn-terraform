output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "zookeeper-fqdn" {
  value = azurerm_public_ip.zookeeper-ip.fqdn
}

output "kafka-fqdn" {
  value = azurerm_public_ip.kafka-ips.*.fqdn
}

output "control-center-fqdn" {
  value = azurerm_public_ip.control-center-ip.fqdn
}

output "platform-components-fqdn" {
  value = azurerm_public_ip.platform-components-ip.fqdn
}

output "tls_private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}
