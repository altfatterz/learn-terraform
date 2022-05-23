resource "random_pet" "rg-name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg-name.id
  location = var.resource_group_location
}

# Create virtual network
resource "azurerm_virtual_network" "myVNet" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "mySubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myVNet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Manages a Linux Virtual Machine Scale Set.
resource "azurerm_linux_virtual_machine_scale_set" "myVMSS" {
  name                = "myVMSS"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.sku
  instances           = var.nr_of_instances
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  # details figured out using: `az vm image list`
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202205100"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "myNIC"
    primary = true

    ip_configuration {
      name      = "myIPConfig"
      primary   = true
      subnet_id = azurerm_subnet.mySubnet.id
    }
  }
}



