/*resource "azurerm_app_service" "app-service-sws-uat-01" {
  name                = "app-service-sws-uat-01"
  resource_group_name = azurerm_resource_group.uat-rg.name
  location            = azurerm_resource_group.uat-rg.location
  app_service_plan_id = azurerm_app_service_plan.gokeodbsws-appservice-plan.id

  site_config {
    dotnet_framework_version = "v6.0"
    #Platform = "32 Bit"
  }
}
 # App Service VNet Swift Connection
resource "azurerm_app_service_virtual_network_swift_connection" "app" {
  app_service_id = azurerm_app_service.app-service-sws-uat-01.id
  subnet_id      = azurerm_subnet.sn2-si.id
}*/
