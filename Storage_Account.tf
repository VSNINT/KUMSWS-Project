resource "azurerm_storage_account" "storageaccprod01" {
  name                     = "storageaccprod01"
  resource_group_name      = azurerm_resource_group.prod-rg.name
  location                 = azurerm_resource_group.prod-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "prod"
  }
}

resource "azurerm_storage_container" "container-prod-01" {
  name                  = "container-prod-01"
  storage_account_id    = azurerm_storage_account.storageaccprod01.id
  container_access_type = "private"
}

