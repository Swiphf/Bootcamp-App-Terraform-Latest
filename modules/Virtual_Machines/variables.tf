# This block defines the application name
variable "app_name" {
  type        = string
  description = "variable for the app's name"
}

# This block defines a varable for resource group name
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

# This block defines a variable for geo location
variable "location" {
  type        = string
  description = "Geographic location"
}

# This block defines a variable for the vm size
variable "vm_size" {
  type        = string
  description = "Virtual machine size"
}

# This block defines a variable for the vnet name, instance number not included
variable "vnet_name" {
  type        = string
  description = "variable for the virtual network name"
}

# This block is for the "password" field to be imported from the main
variable "password" {
  type = string
}

# This block defines a variable for the ubuntu version
variable "vm_sku" {
  type        = string
  description = "ubuntu version"
}

# This block is for the virtual machine type : "app" or "db"
variable "machine_type" {
  type = string
}

# This block is for the "snet_id" field to be imported from the main
variable "snet_id" {
  type = string
}

# This block is for the "vm_name" field to be imported from the main
variable "vm_name" {
  type = string
}

# This block is for the "index" field to be imported from the main
variable "index" {
  type = number
}

# This block is for the "availability_set_id" field to be imported from the main
variable "availability_set_id" {
  type = string
}
