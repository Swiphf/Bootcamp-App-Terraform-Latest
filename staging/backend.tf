terraform {
  backend "azurerm" {
    resource_group_name  = "rg-weighttracker-week9-stage"
   storage_account_name = "tfstate27ltc"
   container_name       = "tfstate"
   key                  = "terraform.tfstate"
 }
}
