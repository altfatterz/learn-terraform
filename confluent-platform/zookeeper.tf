# Create NSG for Zookeeper
resource "azurerm_network_security_group" "zookeeper-nsg" {
  name                = "zookeeper-nsg"
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
    name                       = "FromBrokers"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2181"
    source_address_prefix      = "*"
    destination_address_prefix = "*" # how to limit to kafka-0, kafka-1, kafka-3 only ? Application Security Groups?
  }
}

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
resource "azurerm_network_interface_security_group_association" "zookeeper-nic-to-nsg" {
  network_interface_id      = azurerm_network_interface.zookeeper-nic.id
  network_security_group_id = azurerm_network_security_group.zookeeper-nsg.id
}

# Create VM for Zookeeper
resource "azurerm_linux_virtual_machine" "zookeeper" {
  name                  = "zookeeper"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.zookeeper-nic.id]
  size                  = var.vm_size

  # details figured out using: `az vm image list`
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
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
