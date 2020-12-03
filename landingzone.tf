## declare here the resources for your landing zone

module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "0.4.19"

  current_landingzone_key     = var.landingzone.key
  tfstates                    = local.tfstates
  tags                        = local.tags
  global_settings             = local.global_settings
  diagnostics                 = local.diagnostics
  diagnostic_storage_accounts = var.diagnostic_storage_accounts
  logged_user_objectId        = var.logged_user_objectId
  logged_aad_app_objectId     = var.logged_aad_app_objectId
  resource_groups             = var.resource_groups
  storage_accounts            = var.storage_accounts
  azuread_groups              = var.azuread_groups
  keyvaults                   = var.keyvaults
  keyvault_access_policies    = var.keyvault_access_policies
  managed_identities          = var.managed_identities
  role_mapping                = var.role_mapping
  tenant_id                   = var.tenant_id
  compute = {
    virtual_machines           = var.virtual_machines
    bastion_hosts              = var.bastion_hosts
    aks_clusters               = var.aks_clusters
    azure_container_registries = var.azure_container_registries
  }
  networking = {
    vnets                             = var.vnets
    network_security_group_definition = var.network_security_group_definition
    public_ip_addresses               = var.public_ip_addresses
    private_dns                       = var.private_dns
  }
  database = {
    azurerm_redis_caches        = var.azurerm_redis_caches
    mssql_servers               = var.mssql_servers
    synapse_workspaces          = var.synapse_workspaces
    databricks_workspaces       = var.databricks_workspaces
    machine_learning_workspaces = var.machine_learning_workspaces
  }
  webapp = {
    azurerm_application_insights = var.azurerm_application_insights
  }
  remote_objects = {
    vnets = local.remote.vnets
  }
}
