# This block defines a variable for geo location
variable "location" {
  type        = string
  description = "Geographic location"
}

# This block defines a variable for resource group name
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

# This block defines a variable for db admin username
variable "admin_username" {
  type        = string
  description = "db admin username"
}

# This block defines a variable for db admin password
variable "admin_password" {
  type        = string
  description = "db admin password"
}

# This block defines a public ip
variable "public_ip" {
  type        = string
  description = "app's public ip"
}


# This block defines the environment variables
variable "env" {
  type        = string
  description = "current environment"
}
