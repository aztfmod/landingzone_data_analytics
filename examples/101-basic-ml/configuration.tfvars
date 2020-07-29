## Parameter value assignment

vm_configs = {
  jumpserver = {
    resource_group_name = "vm-rg"
    location            = "southeastasia"
    vnet_key            = "hub_sg"
    subnet_key          = "Subnet_gtw"
    vm_nic_name         = "gtw-vm-nic"
    vm_name             = "jump-server"
    vm_size             = "Standard_D4s_v3"
    os                  = "Windows"
    os_profile = {
      computer_name  = "jump-svr"
      admin_username = "AzureUser"
      admin_password = "AzurePass@123"
    }

    storage_image_reference = {
      publisher = "microsoft-dsvm"
      offer     = "dsvm-windows"
      sku       = "server-2019"
      version   = "latest"
    }

    storage_os_disk = {
      #name              = "${var.os_computer_name}-vm-osdisk"
      name              = "jump-vm-osdisk"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "StandardSSD_LRS"
      disk_size_gb      = "128"
    }
  }
}


aml_configs = {
  aml_sg = {
    resource_group_name       = "dap-automl"
    workspace_name            = "ml-wrkspc44"
    application_insights_name = "ml-app-insht44"

    location   = "southeastasia"
    vnet_key   = "hub_sg"
    subnet_key = "Subnet_storage"

    storage_account = {
      name                      = "amlstorage"
      account_tier              = "Standard"
      account_kind              = "StorageV2"
      account_replication_type  = "LRS"
      access_tier               = "Hot"
      enable_https_traffic_only = true
      is_hns_enabled            = false

      network_rules = {
        default_action = "Deny"
        bypass         = ["AzureServices"]
        #virtual_network_subnet_ids = ["Datalake"]
      }
      #network_rules is optional
    }

    akv_config = {
      name = "akvmlwkspc"
      akv_features = {
        enabled_for_disk_encryption     = true
        enabled_for_deployment          = false
        enabled_for_template_deployment = true
        soft_delete_enabled             = false # Set true in Production
        purge_protection_enabled        = false # Set true in Production
      }
      #akv_features is optional

      sku_name = "premium"
      network_acls = {
        bypass         = "AzureServices"
        default_action = "Deny"
      }
      #network_acls is optional

      diagnostics = {
        log = [
          # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AuditEvent", true, true, 60],
        ]
        metric = [
          #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AllMetrics", true, true, 60],
        ]
      }
    }
  }
}


synapse_configs = {
  synapse_sg = {
    location                 = "southeastasia"
    vnet_key                 = "hub_sg"
    subnet_key               = "Subnet_storage"
    resource_group_name      = "dap-synapse"
    workspace_name           = "synapsewrkspce"
    workspace_tags           = "{\"Type\": \"Data Warehouse\", \"environment\": \"DEV\", \"project\": \"myproject\"}"
    sqlserver_admin_login    = "sqladminuser"
    sqlserver_admin_password = "azureuser@123"

    storage_account = {
      name                      = "synapsestorage"
      account_tier              = "Standard"
      account_kind              = "StorageV2"
      account_replication_type  = "LRS"
      access_tier               = "Hot"
      enable_https_traffic_only = true
      is_hns_enabled            = true ## Must enabled for synpase

      network_rules = {
        default_action = "Deny"
        bypass         = ["AzureServices"]
        #virtual_network_subnet_ids = ["Datalake"]
      }
      #network_rules is optional
    }
  }
}

  