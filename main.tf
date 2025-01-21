provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Spoke Vnet (prod)
resource "azurerm_virtual_network" "vn-si" {
  name                = var.vnet_name
  location            = azurerm_resource_group.prod-rg.location
  resource_group_name = azurerm_resource_group.prod-rg.name
  address_space       = ["10.2.0.0/16"]
}

# Spoke SubNet

resource "azurerm_subnet" "sn2-si" {
  name                 = "subnet-prod-rg-01"
  resource_group_name  = azurerm_resource_group.prod-rg.name
  virtual_network_name = azurerm_virtual_network.vn-si.name
  address_prefixes     = ["10.2.0.0/24"]
 # Add delegation for Microsoft.Web/serverFarms
  delegation {
    name = "MicrosoftWebServerFarmsDelegation"

    service_delegation {
      name = "Microsoft.Web/serverFarms"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_subnet" "sn3-si" {
  name                 = "subnet-prod-rg-02"
  resource_group_name  = azurerm_resource_group.prod-rg.name
  virtual_network_name = azurerm_virtual_network.vn-si.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_subnet" "sn4-si" {
  name                 = "subnet-prod-rg-02"
  resource_group_name  = azurerm_resource_group.prod-rg.name
  virtual_network_name = azurerm_virtual_network.vn-si.name
  address_prefixes     = ["10.2.2.0/24"]
}

#NSG
resource "azurerm_network_security_group" "nsg-si" {
  name                = var.nsg_name
  location            = azurerm_resource_group.prod-rg.location
  resource_group_name = azurerm_resource_group.prod-rg.name
}


