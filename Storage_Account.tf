/*resource "azurerm_storage_account" "storageaccountuat01" {
  name                     = "storageaccountuat01"
  resource_group_name      = azurerm_resource_group.uat-rg.name
  location                 = azurerm_resource_group.uat-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "uat"
  }
}

resource "azurerm_storage_container" "container-uat-01" {
  name                  = "container-uat-01"
  storage_account_id    = azurerm_storage_account.storageaccountuat01.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blob-uat-01" {
  name                   = "blob-uat-01"
  storage_account_name   = azurerm_storage_account.storageaccountuat01.name
  storage_container_name = azurerm_storage_container.container-uat-01.name
  type                   = "Block"
  source                 = "content-file.zip"
}*/
