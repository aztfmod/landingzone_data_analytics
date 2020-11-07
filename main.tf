terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.33.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 1.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 2.2.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
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
      recover_soft_deleted_key_vaults = false
    }
  }
}

data "azurerm_client_config" "current" {}

/* data "terraform_remote_state" "current_networking" {
  for_each = try(var.landingzone.current.networking, {})

  backend = var.landingzone.backend_type
  config = {
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    resource_group_name  = var.tfstate_resource_group_name
    key                  = each.value.tfstate
  }
}

data "terraform_remote_state" "lower_networking" {
  for_each = try(var.landingzone.lower.networking, {})

  backend = var.landingzone.backend_type
  config = {
    storage_account_name = var.lower_storage_account_name
    container_name       = var.lower_container_name
    resource_group_name  = var.lower_resource_group_name
    key                  = each.value.tfstate
  }
}

data "terraform_remote_state" "shared_services" {
  backend = var.landingzone.backend_type
  config = {
    storage_account_name = var.lower_storage_account_name
    container_name       = var.lower_container_name
    resource_group_name  = var.lower_resource_group_name
    key                  = var.landingzone.tfstates.shared_services.tfstate
  }
}
 */

locals {
  /* landingzone_tag = {
    "landingzone" = basename(abspath(path.module))
  }
  tags = merge(local.landingzone_tag, { "level" = var.landingzone.level }, { "environment" = local.global_settings.environment }, { "rover_version" = var.rover_version }, var.tags)

  global_settings = {
    prefix         = try(var.global_settings.prefix, data.terraform_remote_state.shared_services.outputs.global_settings.prefix)
    default_region = try(var.global_settings.default_region, data.terraform_remote_state.shared_services.outputs.global_settings.default_region)
    regions        = try(var.global_settings.regions, null) == null ? data.terraform_remote_state.shared_services.outputs.global_settings.regions : merge(data.terraform_remote_state.shared_services.outputs.global_settings.regions, var.global_settings.regions)
    environment    = data.terraform_remote_state.shared_services.outputs.global_settings.environment
    random_length  = try(var.global_settings.random_length, data.terraform_remote_state.shared_services.outputs.global_settings.random_length)
    passthrough    = try(var.global_settings.passthrough, false)
  }

  diagnostics = {
    diagnostics_definition   = merge(data.terraform_remote_state.shared_services.outputs.diagnostics.diagnostics_definition, var.diagnostics_definition)
    diagnostics_destinations = data.terraform_remote_state.shared_services.outputs.diagnostics.diagnostics_destinations
    storage_accounts         = data.terraform_remote_state.shared_services.outputs.diagnostics.storage_accounts
    log_analytics            = data.terraform_remote_state.shared_services.outputs.diagnostics.log_analytics
  }

  # Merge all remote networking objects
  lower_networking = {
    for key, networking in try(var.landingzone.lower.networking, {}) : key => merge(data.terraform_remote_state.lower_networking[key].outputs.networking[key])
  }
  current_networking = {
    for key, networking in try(var.landingzone.current.networking, {}) : key => merge(data.terraform_remote_state.current_networking[key].outputs.networking[key])
  } */


  tfstates = merge(
    map(var.landingzone.key,
      map(
        "storage_account_name", var.tfstate_storage_account_name,
        "container_name", var.tfstate_container_name,
        "resource_group_name", var.tfstate_resource_group_name,
        "key", var.tfstate_key,
        "level", var.landingzone.level,
        "tenant_id", data.azurerm_client_config.current.tenant_id,
        "subscription_id", data.azurerm_client_config.current.subscription_id
      )
    )
    ,
    #data.terraform_remote_state.shared_services.outputs.tfstates
    data.terraform_remote_state.remote[var.landingzone.global_settings_key].outputs.tfstates
  )
  
}
