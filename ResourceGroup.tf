#Spoke Resource Group (prod)
resource "azurerm_resource_group" "prod-rg" {
  name     = "prod-rg"
  location = "Central India"
}

