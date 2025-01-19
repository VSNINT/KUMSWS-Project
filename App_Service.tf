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
# Data source to reference existing resource group
data "azurerm_resource_group" "uat-rg" {
  name = "uat-rg"
}

# Data source to reference the existing VNet
data "azurerm_virtual_network" "vnet-uat-01" {
  name                = "vnet-uat-01"
  resource_group_name = data.azurerm_resource_group.uat-rg.name
}

# Data source to reference the existing subnet
data "azurerm_subnet" "subnet-uat-rg-01" {
  name                 = "subnet-uat-rg-01"
  virtual_network_name = data.azurerm_virtual_network.vnet-uat-01.name
  resource_group_name  = data.azurerm_resource_group.uat-rg.name
}

# Data source to reference the existing App Service Plan
data "azurerm_app_service_plan" "app-service-plan-sws-uat-rg" {
  name                = "app-service-plan-sws-uat-rg"
  resource_group_name = data.azurerm_resource_group.uat-rg.name
}

resource "azurerm_app_service" "app-service-sws-uat-02" {
  name                = "app-service-sws-uat-02"
  resource_group_name = data.azurerm_resource_group.uat-rg.name
  location            = data.azurerm_resource_group.uat-rg.location
  app_service_plan_id = data.azurerm_app_service_plan.app-service-plan-sws-uat-rg.id

  site_config {
    dotnet_framework_version = "v6.0"
  }
}

# App Service VNet Swift Connection
resource "azurerm_app_service_virtual_network_swift_connection" "app" {
  app_service_id = azurerm_app_service.app-service-sws-uat-02.id
  subnet_id      = data.azurerm_subnet.subnet-uat-rg-01.id
}
