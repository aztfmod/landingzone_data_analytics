resource_groups = {
  vnet_sg = {
    name       = "dap-vnet"
    location   = "southeastasia"
    useprefix  = true
    max_length = 40
  }
}

vnets = {
  hub_sg = {
    resource_group_key = "vnet_sg"
    location           = "southeastasia"
    vnet = {
      name          = "dap-vnet-gtw"
      address_space = ["10.0.0.0/16"]
      #dns                 = ["192.168.0.16", "192.168.0.64"]
    }
    specialsubnets = {
      AzureFirewallSubnet = {
        name = "AzureFirewallSubnet"
        cidr = ["10.0.0.0/19"]
      }
    }
    subnets = {
      Subnet_gtw = {
        name              = "Gateway_VM"
        cidr              = ["10.0.32.0/19"]
        service_endpoints = []
        nsg_name          = "gateway_vm_nsg"
        nsg = [
          {
            name                       = "W32Time",
            priority                   = "100"
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "UDP"
            source_port_range          = "*"
            destination_port_range     = "123"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        ]
      }
      Subnet_storage = {
        name              = "Datalake"
        cidr              = ["10.0.64.0/19"]
        service_endpoints = ["Microsoft.Storage"]
        nsg_name          = "datalake_nsg"
      }
      Subnet_ml = {
        name              = "Ml_Workspace"
        cidr              = ["10.0.96.0/19"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        nsg_name          = "Ml_Workspace_nsg"
      }
      Subnet_synapse = {
        name              = "Synpase_Workspace"
        cidr              = ["10.0.128.0/19"]
        service_endpoints = ["Microsoft.Storage"]
        nsg_name          = "Synapse_Workspace_nsg"
      }
    }
    # Override the default var.diagnostics.vnet
    diagnostics = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
        ["VMProtectionAlerts", true, true, 60],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]                 
        ["AllMetrics", true, true, 60],
      ]
    }
  }
}