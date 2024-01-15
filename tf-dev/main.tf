terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.84.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "web_api_group"
    storage_account_name = "mywebapistorage"
    container_name       = "webapitfstatedev"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

module "environment" {
  source                    = "../modules/tf-environment"
  resource_group_name       = var.resource_group_name
  container_registry_name   = var.container_registry_name
  cosmo_db_account_name     = var.cosmo_db_account_name
  cosmo_sql_db_name         = var.cosmo_sql_db_name
  cosmo_sql_collection_name = var.cosmo_sql_collection_name
  storage_account_name      = var.storage_account_name
  storage_container_name    = var.storage_container_name
  servicebus_namespace_name = var.servicebus_namespace_name
  computer_vision_name      = var.computer_vision_name
}

module "application" {
  source                     = "../modules/tf-application"
  depends_on                 = [module.environment]
  resource_group_common_name = var.resource_group_common_name
  container_registry_name    = var.container_registry_name
  function_app_name          = var.function_app_name
  web_app_name               = var.web_app_name
  app_service_plan_name      = var.app_service_plan_name
  function_service_plan_name = var.function_service_plan_name
  resource_group             = {
    name     = module.environment.resource_group.name
    location = module.environment.resource_group.location
  }
  computer_vision = {
    primary_access_key = module.environment.computer_vision.primary_access_key
    endpoint           = module.environment.computer_vision.endpoint
  }
  cosmo_db = {
    primary_key = module.environment.cosmo_db.primary_key
    endpoint    = module.environment.cosmo_db.endpoint
  }
  servicebus_namespace = {
    default_primary_connection_string = module.environment.servicebus_namespace.default_primary_connection_string
  }
  storage_account = {
    primary_blob_connection_string = module.environment.storage_account.primary_blob_connection_string
    name                           = module.environment.storage_account.name
    primary_access_key             = module.environment.storage_account.primary_access_key
  }
}

