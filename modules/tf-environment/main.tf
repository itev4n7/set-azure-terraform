# Create resource group
resource "azurerm_resource_group" "main_group" {
  name     = var.resource_group_name
  location = "West Europe"
}

# Create storage account
resource "azurerm_storage_account" "storage_account" {
  name                             = var.storage_account_name
  resource_group_name              = azurerm_resource_group.main_group.name
  location                         = azurerm_resource_group.main_group.location
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  cross_tenant_replication_enabled = false

  timeouts {
    create = "120s"
  }
  depends_on = [azurerm_resource_group.main_group]
}

# Create container in storage account
resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  container_access_type = "private"
  storage_account_name  = azurerm_storage_account.storage_account.name
  depends_on            = [azurerm_storage_account.storage_account]
}

# Create cosmosDB
resource "azurerm_cosmosdb_account" "cosmo_db" {
  name                = var.cosmo_db_account_name
  resource_group_name = azurerm_resource_group.main_group.name
  location            = azurerm_resource_group.main_group.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = azurerm_resource_group.main_group.location
    failover_priority = 0
  }
  depends_on = [azurerm_resource_group.main_group]
}

# Create database in cosmosDB
resource "azurerm_cosmosdb_sql_database" "cosmo_sql_db" {
  name                = var.cosmo_sql_db_name
  resource_group_name = azurerm_resource_group.main_group.name
  account_name        = azurerm_cosmosdb_account.cosmo_db.name
  throughput          = 400
  depends_on          = [azurerm_cosmosdb_account.cosmo_db]
}

# Create collection in cosmosDB
resource "azurerm_cosmosdb_sql_container" "sql_collection" {
  name                = var.cosmo_sql_collection_name
  resource_group_name = azurerm_resource_group.main_group.name
  account_name        = azurerm_cosmosdb_account.cosmo_db.name
  database_name       = azurerm_cosmosdb_sql_database.cosmo_sql_db.name
  partition_key_path  = "/timeAdded"
  throughput          = 400
  depends_on          = [azurerm_cosmosdb_sql_database.cosmo_sql_db]
}

# Create service bus namespace
resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  name                = var.servicebus_namespace_name
  location            = azurerm_resource_group.main_group.location
  resource_group_name = azurerm_resource_group.main_group.name
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.main_group]
}

# Create service bus topic
resource "azurerm_servicebus_topic" "servicebus_topic" {
  name                = "webapitopic"
  namespace_id        = azurerm_servicebus_namespace.servicebus_namespace.id
  enable_partitioning = true
  depends_on          = [azurerm_servicebus_namespace.servicebus_namespace]
}

# Create subscription in service bus topic
resource "azurerm_servicebus_subscription" "servicebus_subscription" {
  name                = "subscription1"
  topic_id            = azurerm_servicebus_topic.servicebus_topic.id
  max_delivery_count  = 1
  auto_delete_on_idle = "PT2H"  # Automatically delete after idle for 2 hours
  default_message_ttl = "PT1H"  # Set message time to live for 1 hour
  lock_duration       = "PT5S"  # Set the lock duration to 5 seconds
  depends_on          = [azurerm_servicebus_topic.servicebus_topic]
}

# Create computer vision service
resource "azurerm_cognitive_account" "computer_vision" {
  name                  = var.computer_vision_name
  location              = azurerm_resource_group.main_group.location
  resource_group_name   = azurerm_resource_group.main_group.name
  kind                  = "ComputerVision"
  sku_name              = "S1"
  custom_subdomain_name = var.computer_vision_name
  depends_on            = [azurerm_resource_group.main_group]
}
