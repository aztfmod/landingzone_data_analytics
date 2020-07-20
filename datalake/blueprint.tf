
resource "azurecaf_naming_convention" "nc_storage_rg" {
  name          = var.datalake_config.resource_group_name
  prefix        = var.prefix
  resource_type = "rg"
  max_length    = 50
  convention    = var.convention
}

resource "azurerm_resource_group" "rg_dap_storage" {
  name     = azurecaf_naming_convention.nc_storage_rg.result
  location = var.location
}

# Azure Storage account
module "datalake_storage" {
  source = "../module_azure_storage"

  prefix                 = var.prefix
  convention             = var.convention
  resource_group_name    = azurerm_resource_group.rg_dap_storage.name
  location               = var.location
  storage_account_config = var.datalake_config.storage_account
  subnet_ids             = var.subnet_ids
}

