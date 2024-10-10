locals {
  naming_convention_info = {
    project_code = "project_code"
    env          = "env"
    zone         = "zone"
    tier         = "tier"
    name         = "name"
  }
  tags = {
    environment = "Production"
  }

}
module "resource_groups" {
  source = "git::https://github.com/BrettOJ/tf-az-module-resource-group?ref=main"
  resource_groups = {
    1 = {
      name                   = var.resource_group_name
      location               = var.location
      naming_convention_info = local.naming_convention_info
      tags = {
      }
    }
  }
}


module "azure_private_endpoint" {
  source                        = "../"
  location                      = var.location
  resource_group_name           = module.resource_groups.rg_output[1].name
  subnet_id                     = var.subnet_id
  custom_network_interface_name = var.custom_network_interface_name
  tags                          = local.tags
  naming_convention_info        = local.naming_convention_info

  private_service_connection = {
    name                           = var.private_service_connection_name
    private_connection_resource_id = var.private_service_connection_private_connection_resource_id
    is_manual_connection           = var.private_service_connection_is_manual_connection
    private_connection_resource_alias = var.private_service_connection_private_connection_resource_alias
    subresource_names              = var.private_service_connection_subresource_name
    request_message                   = var.private_service_connection_request_message
  }

  ip_configuration = {
    name               = var.ip_configuration_name
    private_ip_address = var.ip_configuration_private_ip_address
    subresource_name   = var.ip_configuration_subresource_name
    member_name        = var.ip_configuration_member_name
  }

  private_dns_zone_group = {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = [var.private_dns_zone_group_private_dns_zone_ids]
  }

}


