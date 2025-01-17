provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Key Vault creation
resource "azurerm_key_vault" "key-vault" {
  name                        = "Key-vault-rg-common-01" # Key Vault name (must be globally unique)
  location                    = azurerm_resource_group.rg-common.location
  resource_group_name         = azurerm_resource_group.rg-common.name
  enabled_for_disk_encryption = true
  sku_name                    = "standard"                             # Options: Standard, Premium
  tenant_id                   = "283c83d9-5fc7-45b3-b6f4-162da3a2793f" #Your Azure Active Directory tenant ID
  soft_delete_retention_days  = 7                                      # Retention period in days after Key Vault is soft deleted (optional)
  purge_protection_enabled    = false



  access_policy {
    tenant_id = "283c83d9-5fc7-45b3-b6f4-162da3a2793f" #Your Azure Active Directory tenant ID
    object_id = "5ad5a410-25a8-4482-a4f9-3271c5679ec9" #Your Azure Active Directory object ID

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

# Hub Vnet

resource "azurerm_virtual_network" "common-vnet" {
  name                = var.vnetname
  location            = azurerm_resource_group.rg-common.location
  resource_group_name = azurerm_resource_group.rg-common.name
  address_space       = ["10.1.0.0/22"]
}

# Hub SubNet

resource "azurerm_subnet" "common-subnet" {
  name                 = var.subnetname
  resource_group_name  = azurerm_resource_group.rg-common.name
  virtual_network_name = azurerm_virtual_network.common-vnet.name
  address_prefixes     = ["10.1.0.0/25"]
}

# Spoke Vnet (UAT)
resource "azurerm_virtual_network" "vn-si" {
  name                = var.vnet_name
  location            = azurerm_resource_group.uat-rg.location
  resource_group_name = azurerm_resource_group.uat-rg.name
  address_space       = ["10.1.4.0/22"]
}

# Spoke SubNet

resource "azurerm_subnet" "sn2-si" {
  name                 = "subnet-uat-rg-01"
  resource_group_name  = azurerm_resource_group.uat-rg.name
  virtual_network_name = azurerm_virtual_network.vn-si.name
  address_prefixes     = ["10.1.4.0/24"]
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
  name                 = "subnet-uat-rg-02"
  resource_group_name  = azurerm_resource_group.uat-rg.name
  virtual_network_name = azurerm_virtual_network.vn-si.name
  address_prefixes     = ["10.1.5.0/24"]
}

resource "azurerm_subnet" "sn4-si" {
  name                 = "subnet-uat-rg-02"
  resource_group_name  = azurerm_resource_group.uat-rg.name
  virtual_network_name = azurerm_virtual_network.vn-si.name
  address_prefixes     = ["10.1.6.0/24"]
}

#NSG
resource "azurerm_network_security_group" "nsg-si" {
  name                = var.nsg_name
  location            = azurerm_resource_group.uat-rg.location
  resource_group_name = azurerm_resource_group.uat-rg.name
}


##############################################################################################

resource "azurerm_public_ip" "si-gokeodbsws-PubIP" {
  name                = "frontend-ip-app-gtw-rg-common-01"
  location            = azurerm_resource_group.rg-common.location
  resource_group_name = azurerm_resource_group.rg-common.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# since these variables are re-used - a locals block makes this more maintainable
locals {
  frontend_port_name             = "${azurerm_virtual_network.common-vnet.name}-feport"
  backend_address_pool_name      = "${azurerm_virtual_network.common-vnet.name}-beap"
  frontend_ip_configuration_name = "${azurerm_virtual_network.common-vnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.common-vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.common-vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.common-vnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.common-vnet.name}-rdrcfg"
}

resource "azurerm_application_gateway" "Appgateway-si-gokeodbsws-network" {
  name                = "app-gtw-rg-common-01"
  resource_group_name = azurerm_resource_group.rg-common.name
  location            = azurerm_resource_group.rg-common.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }
  

  gateway_ip_configuration {
    name      = "gtw-ip-rg-common-01"
    subnet_id = azurerm_subnet.common-subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.si-gokeodbsws-PubIP.id
  }
 # Reference the existing WAF policy
  firewall_policy_id = azurerm_web_application_firewall_policy.rg-common.id
  

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

resource "azurerm_log_analytics_workspace" "log-analytics-workspace" {
  name                = "log-analytics-workspace-rg-common-01"
  location            = azurerm_resource_group.rg-common.location
  resource_group_name = azurerm_resource_group.rg-common.name
  retention_in_days   = 90
}
