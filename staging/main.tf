# This block specifies the resource group which will contain all the resources.
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# This block defines the Vnet which will be used in this project.
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  address_space       = [var.address_space]
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# This block defines the subnet which will contain the app virtual machines.
resource "azurerm_subnet" "snet_app" {
  name                 = var.subnet_name_app
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.app_address_prefix]
  virtual_network_name = var.vnet_name
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# This block defines the public ip for the app subnet.
resource "azurerm_public_ip" "public_ip" {
  name                = var.app_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# This block creates the virtual machines servers for the app
module "virtual_machines_app" {
  count = var.app_vms_instance_count

  index               = count.index
  vm_name             = "${var.app_name}-${count.index}"
  snet_id             = azurerm_subnet.snet_app.id
  password            = var.app_password
  availability_set_id = azurerm_availability_set.avset.id
  app_name            = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  machine_type        = "app"
  source              = "../modules/Virtual_Machines"
  vm_size             = var.vm_size
  vm_sku              = "18.04-LTS"
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}


# This block creates the storage account required
module "Storage_Accounts" {
  source              = "../modules/Storage_Accounts"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}


# This block creates the postgresql managed service 
module "Postgresql_Server" {
  source              = "../modules/Postgresql_Server"
  location            = var.location
  resource_group_name = var.resource_group_name
  env                 = var.env
  admin_password      = var.db_password
  admin_username      = var.db_admin_username
  public_ip           = azurerm_public_ip.public_ip.ip_address
  depends_on = [
    azurerm_resource_group.rg
  ]
}


# This block creates the availability set
resource "azurerm_availability_set" "avset" {
  name                         = var.avset_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 3
  managed                      = true
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# This block creates the network security group and its rules 
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on = [
    module.virtual_machines_app
  ]

  security_rule {
    name                                       = "AllowHTTPToApp"
    priority                                   = 180
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "8080"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.asg_app.id]
  }

  security_rule {
    name                                       = "AllowSSHSpecificIP"
    priority                                   = 199
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    destination_port_ranges                    = ["8080", "22"]
    source_address_prefix                      = var.admin_ip_address
    destination_application_security_group_ids = [azurerm_application_security_group.asg_app.id]
  }

  security_rule {
    name                                       = "AllowSSHBetweenAppVMs"
    priority                                   = 198
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    destination_port_ranges                    = ["8080", "22"]
    source_address_prefixes                    = module.virtual_machines_app.*.nic_ids_ip_config
    destination_application_security_group_ids = [azurerm_application_security_group.asg_app.id]
  }

  security_rule {
    name                                       = "AllowSSHControllerToApp"
    priority                                   = 197
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    destination_port_ranges                    = ["8080", "22"]
    source_address_prefixes                    = ["172.16.0.4"]
    destination_application_security_group_ids = [azurerm_application_security_group.asg_app.id]
  }


  security_rule {
    name                                       = "DenySSHToApp"
    priority                                   = 200
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.asg_app.id]
  }
}

# This block creates the application security group for the app web servers
resource "azurerm_application_security_group" "asg_app" {
  name                = "app_asg"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}


# This block creates the application security group association for the app web servers
resource "azurerm_network_interface_application_security_group_association" "asg_association_app" {
  count = var.app_vms_instance_count

  network_interface_id          = module.virtual_machines_app.*.nic_ids[count.index].id
  application_security_group_id = azurerm_application_security_group.asg_app.id
  depends_on = [
    azurerm_resource_group.rg
  ]
}


# This block creates the load balancer 
resource "azurerm_lb" "publicLB" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = var.app_public_ip_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# This block creates the load balancer rule
resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.publicLB.id
  name                           = "lb_rule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_public_ip.public_ip.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_address_pool_public.id
}

# This block creates the load balancer rule
resource "azurerm_lb_rule" "lb_rule_open_HTTP" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.publicLB.id
  name                           = "openHTTTP"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = azurerm_public_ip.public_ip.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_address_pool_public.id
}

# This block creates the nic association with the network security group
resource "azurerm_network_interface_security_group_association" "nic-association-nsg-app" {
  count = var.app_nic_associations_count

  network_interface_id      = module.virtual_machines_app.*.nic_ids[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# This block creates the load balancer backend pool
resource "azurerm_lb_backend_address_pool" "backend_address_pool_public" {
  name            = var.lb_backend_address_pool_name
  loadbalancer_id = azurerm_lb.publicLB.id
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# This block creates the backend pool association with the nics
resource "azurerm_network_interface_backend_address_pool_association" "nic_backend_pool_association" {
  count                   = var.app_nic_associations_count
  ip_configuration_name   = "ip_configuration"
  network_interface_id    = module.virtual_machines_app.*.nic_ids[count.index].id
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool_public.id
}
