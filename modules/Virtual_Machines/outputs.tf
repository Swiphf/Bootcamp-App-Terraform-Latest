# This output is used to get the nic id's in the main "main.tf"
output "nic_ids" {
  value = azurerm_network_interface.nic
}

# This output is used to get the virtual machines' private ip's in the main "main.tf"
output "nic_ids_ip_config" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}
