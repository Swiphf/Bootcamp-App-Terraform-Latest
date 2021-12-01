terraform {
  backend "azurerm" {
    resource_group_name  = "rg-weighttracker-week9-prod"
    storage_account_name = "tfstatejs3t9"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
