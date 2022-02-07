variable "name" {
  description = "Name for a single VM. Use 'names' for multiple VMs. "
  type        = string
  default     = ""
}

variable "names" {
  description = "List of VMs names. Has precedence over `name`."
  type        = list(string)
  default     = []
}

variable "resource_group_name" {
  description = "Name for a Resource Group in which you want your AR instance. "
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = ""
}

variable "source_image_blob_uri" {
  description = "URI of the Blob containing the AppResponse VHD."
  type        = string
  default     = ""
}

variable "vm_size" {
  description = "Virtual machine SKU name."
  type        = string
  default     = ""
}

variable "osdisk_name" {
  description = "Name for Managed OS disk that will be used to create AR VM. "
  type        = string
  default     = ""
}

variable "source_uri" {
  description = "Azure storage Blob URL to use as the source of osdisk. URL must end with .vhd extension "
  type        = string
  default     = ""
}

variable "network_interface_ids" {  
  description = "Network Interafce Ids for AR Instance."
  type        = list(string)
  default     = []
}