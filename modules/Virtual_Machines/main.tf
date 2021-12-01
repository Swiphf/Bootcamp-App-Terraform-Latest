# This block defines the virtual machines for the servers.
resource "azurerm_virtual_machine" "vm" {

  name                  = "vm-${var.app_name}-${var.machine_type}-westeu-${var.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  vm_size               = var.vm_size
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, var.index)]
  availability_set_id   = var.machine_type == "app" ? var.availability_set_id : ""

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.vm_sku
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk-${var.machine_type}-${var.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "web-server-${var.index}"
    admin_username = "bootcamp"
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# This block defines the network interfaces which are associated with the virtual machines.
resource "azurerm_network_interface" "nic" {

  name                = "nic-${var.machine_type}-westeu-${var.index}"
  location            = var.location
  resource_group_name = var.resource_group_name


  ip_configuration {
    name                          = var.machine_type == "app" ? "ip_configuration" : "ip_configuration_db"
    subnet_id                     = var.snet_id
    private_ip_address_allocation = "Dynamic"
  }
}
