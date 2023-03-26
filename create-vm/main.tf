resource "random_pet" "rg-name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "myRG" {
  name     = random_pet.rg-name.id
  location = var.resource_group_location
}

# Create a virtual network
resource "azurerm_virtual_network" "myVNet" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name
}

# Create subnet
resource "azurerm_subnet" "mySubNet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.myRG.name
  virtual_network_name = azurerm_virtual_network.myVNet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "myPublicIP" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and Security Rule
resource "azurerm_network_security_group" "myNSG" {
  name                = "myNSG"
  location            = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name

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
}

# Create a Network Interface
resource "azurerm_network_interface" "myNIC" {
  name                = "myNIC"
  location            = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name

  ip_configuration {
    name                          = "myNICIPConfiguration"
    subnet_id                     = azurerm_subnet.mySubNet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myPublicIP.id
  }
}

# Connect the Security Group to the Network Interface
resource "azurerm_network_interface_security_group_association" "myNSGtoNICConfig" {
  network_interface_id      = azurerm_network_interface.myNIC.id
  network_security_group_id = azurerm_network_security_group.myNSG.id
}

# Create (and display) an SSH key
resource "tls_private_key" "myPrivateKey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myVM" {
  name                  = "myVM"
  location              = azurerm_resource_group.myRG.location
  resource_group_name   = azurerm_resource_group.myRG.name
  network_interface_ids = [azurerm_network_interface.myNIC.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "myOSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # details figured out using: `az vm image list`
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = var.hostname
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.myPrivateKey.public_key_openssh
  }
}