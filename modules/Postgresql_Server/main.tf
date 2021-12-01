resource "azurerm_postgresql_server" "psql_server" {
  name                = "psql-weighttracker-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "B_Gen5_1"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  version                      = "11"
  ssl_enforcement_enabled      = false  
}

#Create Postgres firewall rule
resource "azurerm_postgresql_firewall_rule" "postgres_firewall" {
  name                = "psql-firewall"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.psql_server.name
  start_ip_address    = var.public_ip
  end_ip_address      = var.public_ip
}
