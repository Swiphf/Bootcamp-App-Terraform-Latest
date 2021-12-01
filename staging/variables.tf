# This variable will be used as a password for the db virtual machine
variable "db_password" {
  type = string
}

# This variable will be used as a password for the app virtual machines
variable "app_password" {
  type = string
}

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

# This block defines a variable for the vnet name, instance number not included
variable "vnet_name" {
  type        = string
  description = "variable for the virtual network name"
}

# This block defines a variable for the vnet name, instance number not included
variable "address_space" {
  type        = string
  description = "Vnet address space"
}

# This block defines the variable for the subnet app's name
variable "subnet_name_app" {
  type        = string
  description = "Name for the app subnet"
}

variable "vm_size" {
  type        = string
  description = "Size of the virtual machine"
}

# This block defines the address prefix of the app subnet
variable "app_address_prefix" {
  type        = string
  description = "App address prefixes"
}

# This variable defines a name for the network security group
variable "nsg_name" {
  type        = string
  description = "name for the network security group"
}

# This variable defines the only ip address authorized to connect to the virtual machines
variable "admin_ip_address" {
  type        = string
  description = "ip of the person whos authorized to connect to the virtual machines"
}

# This block defines the public ip for the virtual network
variable "app_public_ip_name" {
  type        = string
  description = "name for the public ip field"
}

# This block defines how many app virtual machines will be created
variable "app_vms_instance_count" {
  type        = number
  description = "number of instances of a virtual machine to create for app"
}

# This block defines a name for the availability set 
variable "avset_name" {
  type        = string
  description = "variable for availability set name"
}

# This block defines a name for the load balancer
variable "lb_name" {
  type        = string
  description = "variable for the load balancer name"
}

# This block defines a name for the load balancer backend pool
variable "lb_backend_address_pool_name" {
  type        = string
  description = "variable for lb backend address pool name "
}

# This block defines the amount of the nics that will be created for the app virtual machines
variable "app_nic_associations_count" {
  type        = number
  description = "number of instances of a nic to create for app"
}

# This block defines the charset
variable "charset" {
  type        = string
  description = "variable for charset"
}

# This block defines the name for the postgresql server
variable "psql_name" {
  type        = string
  description = "variable for charset"
}

# This block defines the sku name for the postgresql server
variable "sku_name_psql" {
  type        = string
  description = "variable for charset"
}

# This block defines the admin username for the postgresql server
variable "db_admin_username" {
  type        = string
  description = "variable for the db admin username"
}

# This block defines the current environment
variable "env" {
  type        = string
  description = "variable for the environment type"
}
