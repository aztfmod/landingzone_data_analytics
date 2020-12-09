output caf {
  value     = module.caf
  sensitive = true
}

output global_settings {
  value     = local.global_settings
  sensitive = true
}

output diagnostics {
  value     = local.diagnostics
  sensitive = true
}

output tfstates {
  value     = local.tfstates
  sensitive = true
}