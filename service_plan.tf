resource "azurerm_app_service_plan" "gokeodbsws-appservice-plan" {
  name                = "app-service-plan-sws-prod-rg"
  resource_group_name = azurerm_resource_group.prod-rg.name
  location            = azurerm_resource_group.prod-rg.location
  kind                = "Windows" # Can be "Windows" depending on your needs
  reserved            = false     
  sku {
    tier = "Standard"
    size = "S2"
  }
}
