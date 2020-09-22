terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.27.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.0.0"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = "~> 0.2.5"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

data "terraform_remote_state" "landingzone" {
  backend = "azurerm"
  config = {
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = var.tfstate_key
    resource_group_name  = var.tfstate_resource_group_name
  }
}

locals {
  caf = data.terraform_remote_state.landingzone.outputs.caf

  tags = merge(var.tags, { "level" = var.level }, { "environment" = var.environment }, { "rover_version" = var.rover_version })

  global_settings = {
    prefix         = data.terraform_remote_state.landingzone.outputs.global_settings.prefix
    convention     = try(var.global_settings.convention, data.terraform_remote_state.landingzone.outputs.global_settings.convention)
    default_region = try(var.global_settings.default_region, data.terraform_remote_state.landingzone.outputs.global_settings.default_region)
    environment    = data.terraform_remote_state.landingzone.outputs.global_settings.environment
    regions        = try(var.global_settings.regions, data.terraform_remote_state.landingzone.outputs.global_settings.regions)
    max_length     = try(var.max_length, data.terraform_remote_state.landingzone.outputs.global_settings.max_length)
  }

  diagnostics = {
    diagnostics_definition   = merge(data.terraform_remote_state.landingzone.outputs.diagnostics.diagnostics_definition, var.diagnostics_definition)
    diagnostics_destinations = data.terraform_remote_state.landingzone.outputs.diagnostics.diagnostics_destinations
    storage_accounts         = data.terraform_remote_state.landingzone.outputs.diagnostics.storage_accounts
    log_analytics            = data.terraform_remote_state.landingzone.outputs.diagnostics.log_analytics
  }

  tfstates = merge(
    map(var.landingzone_name,
      map(
        "storage_account_name", var.tfstate_storage_account_name,
        "container_name", var.tfstate_container_name,
        "resource_group_name", var.tfstate_resource_group_name,
        "key", var.tfstate_key,
        "level", var.level,
        "tenant_id", data.azurerm_client_config.current.tenant_id,
        "subscription_id", data.azurerm_client_config.current.subscription_id
      )
    )
    ,
    data.terraform_remote_state.landingzone.outputs.tfstates
  )

}
