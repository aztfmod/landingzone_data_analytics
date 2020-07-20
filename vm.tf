## need to update modules to use naming provider and modern VM creation

module "caf-nic" {
  source  = "aztfmod/caf-nic/azurerm"
  version = "0.2.2"

  for_each = var.vm_configs

  prefix              = local.prefix
  tags                = var.tags
  location            = each.value.location
  resource_group_name = local.vnets[each.value.vnet_key].vnet_obj.resource_group_name

  name       = each.value.vm_nic_name
  convention = local.global_settings.convention
  subnet_id  = local.vnets[each.value.vnet_key].subnet_ids_map[each.value.subnet_key].id

}

module "caf-vm" {
  source  = "aztfmod/caf-vm/azurerm"
  version = "0.1.0"

  for_each = var.vm_configs

  prefix                       = local.prefix
  convention                   = local.global_settings.convention
  name                         = each.value.vm_name
  resource_group_name          = local.vnets[each.value.vnet_key].vnet_obj.resource_group_name
  location                     = each.value.location
  tags                         = var.tags
  network_interface_ids        = [module.caf-nic[each.key].id]
  primary_network_interface_id = module.caf-nic[each.key].id
  os                           = each.value.os
  os_profile                   = each.value.os_profile
  storage_image_reference      = each.value.storage_image_reference
  storage_os_disk              = each.value.storage_os_disk
  vm_size                      = each.value.vm_size
}
