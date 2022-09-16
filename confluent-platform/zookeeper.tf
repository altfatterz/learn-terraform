# Create Public IP for Zookeeper
resource "azurerm_public_ip" "zookeeper-ip" {
  name                = "zookeeper-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "zookeeper-${random_string.fqdn.result}"
}

# Create NIC for Zookeeper Host
resource "azurerm_network_interface" "zookeeper-nic" {
  name                = "zookeeper-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "zookeeper-nic-ip-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.zookeeper-ip.id
  }
}

# Associate the NIC to the NSG
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.zookeeper-nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create VM for Zookeeper
resource "azurerm_linux_virtual_machine" "zookeeper" {
  name                  = "zookeeper"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.zookeeper-nic.id]
  size                  = "Standard_B1s"

  # details figured out using: `az vm image list`
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "zookeeper-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name                   = "zookeeper"
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.key.public_key_openssh
  }
}
