provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
  }
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>0.4.3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.20.0"
    }
  }
  required_version = ">= 0.13"
}

data "terraform_remote_state" "landingzone_networking" {
  backend = "azurerm"
  config = {
    storage_account_name = var.lowerlevel_storage_account_name
    container_name       = var.workspace
    resource_group_name  = var.lowerlevel_resource_group_name
    key                  = var.tfstate_landingzone_networking
  }
}

data "terraform_remote_state" "landingzone_caf_foundations" {
  backend = "azurerm"
  config = {
    storage_account_name = var.lowerlevel_storage_account_name
    container_name       = var.workspace
    resource_group_name  = var.lowerlevel_resource_group_name
    key                  = var.tfstate_landingzone_caf_foundations
  }
}

locals {
  landingzone_tag = {
    "landingzone" = basename(abspath(path.module))
  }

  global_settings = data.terraform_remote_state.landingzone_caf_foundations.outputs.global_settings

  prefix                     = local.global_settings.prefix
  tags                       = merge(var.tags, local.landingzone_tag, { "environment" = local.global_settings.environment })
  caf_foundations_accounting = data.terraform_remote_state.landingzone_caf_foundations.outputs.foundations_accounting
  vnets                      = data.terraform_remote_state.landingzone_networking.outputs.vnets
}
