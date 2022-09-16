# Create NSG for control-center
resource "azurerm_network_security_group" "control-center-nsg" {
  name                = "control-center-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "For browser access to Confluent Control Center"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9021"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Create Public IP for control-center
resource "azurerm_public_ip" "control-center-ip" {
  name                = "control-center-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "control-center-${random_string.fqdn.result}"
}

# Create NIC for control-center Host
resource "azurerm_network_interface" "control-center-nic" {
  name                = "control-center-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "control-center-nic-ip-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.control-center-ip.id
  }
}

# Associate the NIC to the NSG
resource "azurerm_network_interface_security_group_association" "control-center-nic-to-nsg" {
  network_interface_id      = azurerm_network_interface.control-center-nic.id
  network_security_group_id = azurerm_network_security_group.control-center-nsg.id
}

# Create VM for control-center
resource "azurerm_linux_virtual_machine" "control-center" {
  name                  = "control-center"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.control-center-nic.id]
  size                  = var.vm_size

  # details figured out using: `az vm image list`
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "control-center-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name                   = "control-center"
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.key.public_key_openssh
  }
}
