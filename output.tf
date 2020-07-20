## define here the outputs you want to expose to higher level landing zone


## re-exporting level1 settings (caf_foundations) for level 3 consumption
output "prefix" {
  description = "Prefix"
  value       = local.prefix
}

output "landingzone_caf_foundations_accounting" {
  description = "Full output of the accounting settings"
  sensitive   = false # to hide content from logs
  value       = local.caf_foundations_accounting
}

output "landingzone_caf_foundations_global_settings" {
  description = "Full output of the global settings object"
  sensitive   = false # to hide content from logs
  value       = local.global_settings
}

## landing zone outputs

output "datalake_storage" {
  description = "Full output of the data lake storage objects"
  sensitive   = false # to hide content from logs
  value       = module.datalake_storage
}

output "dap_synapse_workspace" {
  description = "Full output of the Synapse objects"
  sensitive   = false # to hide content from logs
  value       = module.dap_synapse_workspace
}

output "dap_aml_workspace" {
  description = "Full output of the Azure Machine learning objects"
  sensitive   = false # to hide content from logs
  value       = module.dap_aml_workspace
}