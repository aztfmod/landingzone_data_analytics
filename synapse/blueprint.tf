# Create Azure Synpase Analytics with ARM template

resource "azurecaf_naming_convention" "nc_synapse_rg" {
  name          = var.synapse_config.resource_group_name
  prefix        = var.prefix
  resource_type = "rg"
  max_length    = 50
  convention    = var.convention
}

resource "azurecaf_naming_convention" "nc_filesystem" {
  name          = "synapse-fs"
  prefix        = var.prefix
  resource_type = "st"
  max_length    = 30
  convention    = var.convention
}

resource "azurecaf_naming_convention" "nc_deployment_template_name" {
  name          = "synapse"
  prefix        = var.prefix
  resource_type = "gen"
  max_length    = 30
  convention    = var.convention
}

resource "azurecaf_naming_convention" "nc_workspace_name" {
  name          = var.synapse_config.workspace_name
  prefix        = var.prefix
  resource_type = "gen"
  max_length    = 40
  convention    = var.convention
}

resource "azurerm_resource_group" "rg_synapse_analytics" {
  name     = azurecaf_naming_convention.nc_synapse_rg.result
  location = var.location
}


module "synapse_storage" {
  source = "../module_azure_storage"

  prefix                 = var.prefix
  convention             = var.convention
  resource_group_name    = azurerm_resource_group.rg_synapse_analytics.name
  location               = var.location
  storage_account_config = var.synapse_config.storage_account
  subnet_ids             = var.subnet_ids
}



resource "azurerm_template_deployment" "synapse_workspace" {
  name                = azurecaf_naming_convention.nc_deployment_template_name.result
  resource_group_name = azurerm_resource_group.rg_synapse_analytics.name

  template_body = file("${path.module}/arm_synapse_workspace.json")

  parameters = {
    "managedVirtualNetwork" = var.vnet
    "name"                  = azurecaf_naming_convention.nc_workspace_name.result

    "sqlAdministratorLogin"               = var.synapse_config.sqlserver_admin_login
    "sqlAdministratorLoginPassword"       = var.synapse_config.sqlserver_admin_password
    "grantWorkspaceIdentityControlForSql" = "Enabled"

    "defaultDataLakeStorageAccountName"    = module.synapse_storage.storage_account.name
    "defaultDataLakeStorageFilesystemName" = azurecaf_naming_convention.nc_filesystem.result
    #"storageResourceGroupName" = var.storage_resource_group
    "tagValues" = var.synapse_config.workspace_tags
  }

  deployment_mode = "Incremental"

  depends_on = [
    azurerm_resource_group.rg_synapse_analytics,
    module.synapse_storage,
    var.vnet,
    azurecaf_naming_convention.nc_filesystem
  ]
}
