# environment part
variable "resource_group_name" {
  description = "Name of the existing Azure resource group"
  type        = string
}

variable "container_registry_name" {
  description = "Name of the existing Azure container registry"
  type        = string
}

variable "cosmo_db_account_name" {
  description = "Name for new resource of Azure cosmoDB account"
  type        = string
}

variable "cosmo_sql_db_name" {
  description = "Name for new resource of Azure standard db in cosmoDB"
  type        = string
}

variable "cosmo_sql_collection_name" {
  description = "Name for new resource of Azure standard collection in cosmoDB"
  type        = string
}

variable "storage_account_name" {
  description = "Name for new resource of Azure storage account"
  type        = string
}

variable "storage_container_name" {
  description = "Name for new resource of Azure storage container"
  type        = string
}

variable "servicebus_namespace_name" {
  description = "Name for new resource of Azure service bus namespace"
  type        = string
}

variable "computer_vision_name" {
  description = "Name for new resource of Azure computer vision"
  type        = string
}

# application part
variable "resource_group_common_name" {
  description = "Name of the existing Azure resource group"
  type        = string
}

variable "function_app_name" {
  description = "Name for new resource of Azure function app"
  type        = string
}

variable "web_app_name" {
  description = "Name for new resource of Azure web app"
  type = string
}

variable "app_service_plan_name" {
  description = "Name for new resource of Azure service plan for web app"
  type        = string
}

variable "function_service_plan_name" {
  description = "Name for new resource of Azure service plan for function app"
  type        = string
}