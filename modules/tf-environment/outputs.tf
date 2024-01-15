output "resource_group" {
  value = azurerm_resource_group.main_group
}

output "computer_vision" {
  value = azurerm_cognitive_account.computer_vision
}

output "cosmo_db" {
  value = azurerm_cosmosdb_account.cosmo_db
}

output "servicebus_namespace" {
  value = azurerm_servicebus_namespace.servicebus_namespace
}

output "storage_account" {
  value = azurerm_storage_account.storage_account
}
