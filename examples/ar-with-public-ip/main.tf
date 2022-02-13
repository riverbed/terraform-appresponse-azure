terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "terraform_demo" {
    name     = "terraformDemo"
    location = "West Europe"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_virtual_network" "terraform_demo_vnet" {
  name                = "${azurerm_resource_group.terraform_demo.name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraform_demo.location
  resource_group_name = azurerm_resource_group.terraform_demo.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.terraform_demo.name
  virtual_network_name = azurerm_virtual_network.terraform_demo_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "terraform-ar-demo-pip"
  resource_group_name = azurerm_resource_group.terraform_demo.name
  location            = azurerm_resource_group.terraform_demo.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  name                = "terraform-ar-demo-nic1"
  resource_group_name = azurerm_resource_group.terraform_demo.name
  location            = azurerm_resource_group.terraform_demo.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface" "internal" {
  name                      = "terraform-ar-demo-nic2"
  resource_group_name       = azurerm_resource_group.terraform_demo.name
  location                  = azurerm_resource_group.terraform_demo.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

module "appresponse_instance" {
  source = "github.com/riverbed/terraform-appresponse-azure"

  name                = "terraform-ar-demo-instance"
  resource_group_name = azurerm_resource_group.terraform_demo.name
  location            = "West Europe"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size             = "Standard_B8MS"
  osdisk_name         = "terraform_demo_ar_osdisk"
  source_uri          = "<Source URI for OS disk>"
  storage_account_id  = "<Azure storage account ID>"
}
