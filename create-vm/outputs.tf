output "resource_group_name" {
  value = azurerm_resource_group.myRG.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.myVM.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.myPrivateKey.private_key_pem
  sensitive = true
}