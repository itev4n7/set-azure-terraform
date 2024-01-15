variable "resource_group" {
  description = "Object of the existing Azure resource group"
  type        = object({ name = string, location = string })
}

variable "resource_group_common_name" {
  description = "Name of the existing Azure resource group"
  type        = string
}

variable "container_registry_name" {
  description = "Name of the existing Azure container registry"
  type        = string
}

variable "cosmo_db" {
  description = "Name for new resource of Azure cosmoDB account"
  type        = object({ primary_key = string, endpoint = string })
}

variable "storage_account" {
  description = "Name for new resource of Azure storage account"
  type        = object({ primary_blob_connection_string = string, name = string, primary_access_key = string })
}

variable "servicebus_namespace" {
  description = "Name for new resource of Azure service bus namespace"
  type        = object({ default_primary_connection_string = string })
}

variable "computer_vision" {
  description = "Name for new resource of Azure computer vision"
  type        = object({ primary_access_key = string, endpoint = string })
}

variable "function_app_name" {
  description = "Name for new resource of Azure function app"
  type        = string
}

variable "web_app_name" {
  description = "Name for new resource of Azure web app"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name for new resource of Azure service plan for web app"
  type        = string
}

variable "function_service_plan_name" {
  description = "Name for new resource of Azure service plan for function app"
  type        = string
}
