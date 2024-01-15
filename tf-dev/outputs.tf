output "resource_group" {
  description = "The name of the created resource group"
  value       = module.environment.resource_group.name
}