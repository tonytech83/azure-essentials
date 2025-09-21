# 1. Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.113.0"
    }
  }
}

# 2. Configure the AzureRM Provider
provider "azurerm" {
  features {}
}

# 3. Create a resource group
resource "azurerm_resource_group" "arg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# 4. Networking
# 4.1 Virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-vnet"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  address_space       = ["10.0.0.0/16"]
}

# 4.2 Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.arg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4.3 Public IP (Standard, static)
resource "azurerm_public_ip" "pip" {
  name                = "${var.virtual_machine_name}-pip"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 4.4 Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.virtual_machine_name}-nic"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# 4.5 Minimal NSG to allow SSH and HTTP 8080
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_group_name}-nsg"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name

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
    name                       = "HTTP-8080"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 5. Create Ubuntu Server 24.04 based virtual machine
resource "azurerm_linux_virtual_machine" "alvm" {
  name                = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  size                = "Standard_B1s"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_username                  = "azure-admin"
  disable_password_authentication = true
  admin_ssh_key {
    username   = "azure-admin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# 6. Create new disk
resource "azurerm_managed_disk" "amd" {
  name                 = "${var.virtual_machine_name}-data-disk"
  resource_group_name  = azurerm_resource_group.arg.name
  location             = azurerm_resource_group.arg.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 20
  depends_on = [ azurerm_linux_virtual_machine.alvm ]
}

# 7. Attach the new disk to the VM
resource "azurerm_virtual_machine_data_disk_attachment" "avmdda" {
  virtual_machine_id = azurerm_linux_virtual_machine.alvm.id
  managed_disk_id    = azurerm_managed_disk.amd.id
  lun                = 0
  caching            = "ReadWrite"
  depends_on = [ azurerm_managed_disk.amd ]
}

# 8. Custom script
## Apache install
## Create new index page
## Change HTTP port from 80 to 8080

resource "azurerm_virtual_machine_extension" "custom-script" {
  name                 = "custom-script"
  virtual_machine_id   = azurerm_linux_virtual_machine.alvm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = "bash -c 'export DEBIAN_FRONTEND=noninteractive && apt-get update && sudo apt-get install apache2 -y && sudo systemctl enable --now apache2 && echo \"<h1>Hello Azure</h1>\" | sudo tee /var/www/html/index.html && sudo sed -i \"s/Listen 80/Listen 8080/\" /etc/apache2/ports.conf && sudo sed -i \"s/:80>/:8080>/\" /etc/apache2/sites-available/000-default.conf && sudo systemctl restart apache2'"
  })
  
  depends_on = [
    azurerm_linux_virtual_machine.alvm,
    azurerm_virtual_machine_data_disk_attachment.avmdda
  ]
}
