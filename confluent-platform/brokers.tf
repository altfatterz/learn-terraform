# Create NSG
resource "azurerm_network_security_group" "kafka-nsg" {
  name                = "kafka-nsg"
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
    name                       = "Inter_Broker_Communication"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9091"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Kafka_AdminClient_API_And_Custom_Applications"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9092"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create Public IPs for Kafka instances
resource "azurerm_public_ip" "kafka-ips" {
  count               = var.broker_count
  name                = "kafka-${count.index}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "kafka-${count.index}-${random_string.fqdn.result}"
}

# Create network interface
resource "azurerm_network_interface" "kafka-nics" {
  count               = var.broker_count
  name                = "kafka-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "kafka-nic-${count.index}-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.kafka-ips.*.id, count.index)
  }
}

# Associate the NICs to the NSG
resource "azurerm_network_interface_security_group_association" "nic_to_nsg" {
  count                     = var.broker_count
  network_interface_id      = element(azurerm_network_interface.kafka-nics.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.kafka-nsg.id
}

# Create virtual machines for kafka broker
resource "azurerm_linux_virtual_machine" "kafka" {
  count                 = var.broker_count
  name                  = "kafka-${count.index}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.kafka-nics.*.id, count.index)]
  size                  = var.broker_vm_size

  # details figured out using: `az vm image list`
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "kafkak-os-disk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name                   = "kafka-${count.index}"
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.key.public_key_openssh
  }
}
