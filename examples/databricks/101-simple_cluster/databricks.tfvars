level = "level3"

tfstates = {
  caf_foundations = {
    tfstate = "caf_foundations.tfstate"
  }
  networking = {
    tfstate = "networking_spoke_databricks.tfstate"
  }
}

resource_groups = {
  databricks_re1 = {
    name   = "databricks-re1"
    region = "region1"
  }
}


databricks_workspaces = {
  sales_workspaces = {
    name               = "sales_workspace"
    resource_group_key = "databricks_re1"
    sku                = "standard"
    custom_parameters = {
      no_public_ip       = false
      remote_tfstate = {
        tfstate_key = "databricks_networking_spoke"
        output_key  = "vnets"
        lz_key      = "databricks_networking_spoke"
        vnet_key    = "vnet_spoke_data_re1"
      }
      public_subnet_key  = "databricks_public"
      private_subnet_key = "databricks_private"
    }
  }
}

databricks = {
  workspace_key           = "sales_workspaces"
  name                    = "Sales Autoscaling"
  spark_version           = "6.6.x-scala2.11"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 20
  autoscale = {
    min_workers = 1
    max_workers = 50
  }
  spark_conf = {
    "spark.databricks.io.cache.enabled"          = true,
    "spark.databricks.io.cache.maxDiskUsage"     = "50g",
    "spark.databricks.io.cache.maxMetaDataCache" = "1g"
  }
}

keyvaults = {
  secrets_re1 = {
    name               = "secrets"
    resource_group_key = "databricks_re1"
    sku_name           = "standard"
  }
}

keyvault_access_policies = {
  # A maximum of 16 access policies per keyvault
  secrets_re1 = {
    logged_in_user = {
      secret_permissions = ["Set", "Get", "List", "Delete", "Purge"]
    }
    logged_in_aad_app = {
      secret_permissions = ["Set", "Get", "List", "Delete", "Purge"]
    }
  }
}
