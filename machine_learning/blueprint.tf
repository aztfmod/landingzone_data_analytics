# Machine Learning Workload

# data "azurerm_client_config" "current" {}

resource "azurecaf_naming_convention" "nc_aml_rg" {
  name          = var.aml_config.resource_group_name
  prefix        = var.prefix
  resource_type = "rg"
  max_length    = 50
  convention    = var.convention
}

resource "azurecaf_naming_convention" "nc_aml_appinsight" {
  name          = var.aml_config.application_insights_name
  prefix        = var.prefix
  resource_type = "appi"
  max_length    = 50
  convention    = var.convention
}

resource "azurecaf_naming_convention" "nc_aml_wrkspc" {
  name          = var.aml_config.workspace_name
  prefix        = var.prefix
  resource_type = "gen"
  max_length    = 30
  convention    = "passthrough"
}

resource "azurerm_resource_group" "rg_dap_aml" {
  name     = azurecaf_naming_convention.nc_aml_rg.result
  location = var.location
}


module "aml_storage" {
  source = "../module_azure_storage"

  prefix                 = var.prefix
  convention             = var.convention
  resource_group_name    = azurerm_resource_group.rg_dap_aml.name
  location               = var.location
  storage_account_config = var.aml_config.storage_account
  subnet_ids             = var.subnet_ids
}

# Insight ID for ML Workspace
resource "azurerm_application_insights" "ml_workspace_insight" {
  name                = azurecaf_naming_convention.nc_aml_appinsight.result
  location            = azurerm_resource_group.rg_dap_aml.location
  resource_group_name = azurerm_resource_group.rg_dap_aml.name
  application_type    = "web"

  depends_on = [azurerm_resource_group.rg_dap_aml]
}


# Keyvault for ML Workspace
module "caf-keyvault" {
  source = "github.com/aztfmod/terraform-azurerm-caf-keyvault?ref=vnext"
  # source  = "aztfmod/caf-keyvault/azurerm"
  # version = "2.0.2"

  prefix                  = var.prefix
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg_dap_aml.name
  akv_config              = var.akv_config
  tags                    = var.tags
  diagnostics_settings    = var.akv_config.diagnostics
  diagnostics_map         = var.diagnostics_map
  log_analytics_workspace = var.log_analytics_workspace
  convention              = "passthrough"
}


# ML Workspace
resource "azurerm_machine_learning_workspace" "dap_ml_workspace" {
  name                    = azurecaf_naming_convention.nc_aml_wrkspc.result
  location                = azurerm_resource_group.rg_dap_aml.location
  resource_group_name     = azurerm_resource_group.rg_dap_aml.name
  application_insights_id = azurerm_application_insights.ml_workspace_insight.id
  key_vault_id            = module.caf-keyvault.id
  storage_account_id      = module.aml_storage.storage_account.id

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_resource_group.rg_dap_aml,
    module.aml_storage,
    module.caf-keyvault,
    azurerm_application_insights.ml_workspace_insight
  ]
}