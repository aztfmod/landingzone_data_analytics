# Map of the remote data state
variable lowerlevel_storage_account_name {}
variable lowerlevel_container_name {}
variable lowerlevel_key {} # Keeping the key for the lower level0 access
variable lowerlevel_resource_group_name {}
variable workspace {}
variable tfstate_landingzone_networking {
  description = "(Optional) Name of the Terraform state for the networking landing zone"
  default     = "landingzone_networking.tfstate"
}

variable tfstate_landingzone_caf_foundations {
  description = "(Optional) Name of the Terraform state for the caf foundations landing zone"
  default     = "landingzone_caf_foundations.tfstate"
}

variable tags {
  description = "(Optional) Tags for the landing zone"
  type        = map
  default = {
    "environment" : "DEV"
    "project" : "my_analytics_project"
  }
}

variable vm_configs {
  description = "(Required) Virtual Machine Configuration objects"
}

variable datalake_configs {
  description = "(Required) Data Lake Configuration objects"
}

variable aml_configs {
  description = "(Required) Machine learning Configuration objects"
}

variable synapse_configs {
  description = "(Required) Synapse Configuration objects"
}

