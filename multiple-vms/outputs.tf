output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "fqdn" {
  value = azurerm_public_ip.ips.*.fqdn
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}
