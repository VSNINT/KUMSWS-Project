resource "azurerm_app_service_plan" "gokeodbsws-appservice-plan" {
  name                = "app-service-plan-sws-uat-rg"
  resource_group_name = azurerm_resource_group.uat-rg.name
  location            = azurerm_resource_group.uat-rg.location
  kind                = "Windows" # Can be "Windows" depending on your needs
  reserved            = false     
  sku {
    tier = "Standard"
    size = "S2"
  }
}
