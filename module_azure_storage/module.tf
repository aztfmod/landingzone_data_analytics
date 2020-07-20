
## Module to create storage account

resource "azurecaf_naming_convention" "nc_storage_account" {
  name          = var.storage_account_config.name
  prefix        = var.prefix
  resource_type = "st"
  max_length    = 50
  convention    = var.convention
}


# Azure Storage account
resource "azurerm_storage_account" "azure_storage" {
  name                = azurecaf_naming_convention.nc_storage_account.result
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind              = lookup(var.storage_account_config, "account_kind", null)
  account_tier              = lookup(var.storage_account_config, "account_tier", null)
  account_replication_type  = lookup(var.storage_account_config, "account_replication_type", null)
  access_tier               = lookup(var.storage_account_config, "access_tier", null)
  enable_https_traffic_only = lookup(var.storage_account_config, "enable_https_traffic_only", null)
  is_hns_enabled            = lookup(var.storage_account_config, "is_hns_enabled", null)

  dynamic "network_rules" {
    for_each = lookup(var.storage_account_config, "network_rules", {}) != {} ? [1] : []

    content {
      default_action             = lookup(var.storage_account_config.network_rules, "default_action", null)
      bypass                     = lookup(var.storage_account_config.network_rules, "bypass", null)
      virtual_network_subnet_ids = [var.subnet_ids]
    }
  }

  depends_on = [
    var.subnet_ids,
    var.resource_group_name
  ]
}

