# This output will be used to get a password for the app virtual machine from the user
output "app_password" {
  value = var.app_password
}

# This output will be used to get a password for the db virtual machine from the user
output "db_password" {
  value = var.db_password
}