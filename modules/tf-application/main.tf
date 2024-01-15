# Get resource group
data "azurerm_resource_group" "common_group" {
  name = var.resource_group_common_name
}

# Get container registry
data "azurerm_container_registry" "container_registry" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.common_group.name
  depends_on          = [data.azurerm_resource_group.common_group]
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_service_plan" "function_service_plan" {
  name                = var.function_service_plan_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

# Create function app
resource "azurerm_windows_function_app" "function_app" {
  name                       = var.function_app_name
  resource_group_name        = var.resource_group.name
  location                   = var.resource_group.location
  service_plan_id            = azurerm_service_plan.function_service_plan.id
  storage_account_name       = var.storage_account.name
  storage_account_access_key = var.storage_account.primary_access_key

  site_config {
    use_32_bit_worker=true
  }
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
  }
  depends_on = [azurerm_service_plan.function_service_plan]
}

resource "azurerm_linux_web_app" "web_app" {
  name                = var.web_app_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    always_on = true
    application_stack {
      docker_image_name        = "set-azure-project:latest"
      docker_registry_url      = "https://${data.azurerm_container_registry.container_registry.login_server}"
      docker_registry_username = data.azurerm_container_registry.container_registry.admin_username
      docker_registry_password = data.azurerm_container_registry.container_registry.admin_password
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
    "BLOB_STORAGE_CONNECTION_STRING"      = var.storage_account.primary_blob_connection_string
    "SERVICE_BUS_CONNECTION_STRING"       = var.servicebus_namespace.default_primary_connection_string
    "COSMO_DB_KEY"                        = var.cosmo_db.primary_key
    "COSMO_DB_ENDPOINT"                   = var.cosmo_db.endpoint
    "COMPUTER_VISION_KEY"                 = var.computer_vision.primary_access_key
    "COMPUTER_VISION_ENDPOINT"            = var.computer_vision.endpoint
  }

  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_service_plan.app_service_plan]
}

