# Create AppResponse VM in Azure
resource "azurerm_managed_disk" "ar_osdisk" {
  name                = var.osdisk_name
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_type = "Standard_LRS"

  create_option = "Import"
  source_uri    = var.source_uri
  storage_account_id = ""
  disk_size_gb  = "2048"
}

resource "azurerm_virtual_machine" "ar_instance" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = var.network_interface_ids
  vm_size               = var.vm_size

  storage_os_disk {
    name              = var.osdisk_name
    caching           = "ReadWrite"
    create_option     = "Attach"
    managed_disk_type = "Standard_LRS"
    managed_disk_id   = azurerm_managed_disk.ar_osdisk.id
    os_type = "Linux"
  }

}
