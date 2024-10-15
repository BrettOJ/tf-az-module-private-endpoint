
resource "azurerm_private_endpoint" "az_private_endpoint" {
  name                          = module.azpe_name.naming_convention_output[var.naming_convention_info.name].names.0
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.subnet_id
  custom_network_interface_name = var.custom_network_interface_name
  tags                          = var.tags


  private_service_connection {
    name                              = var.private_service_connection.name
    private_connection_resource_id    = var.private_service_connection.private_connection_resource_id
    is_manual_connection              = var.private_service_connection.is_manual_connection
    private_connection_resource_alias = var.private_service_connection.private_connection_resource_alias
    subresource_names                 = var.private_service_connection.subresource_names
    request_message                   = var.private_service_connection.request_message
  }

  dynamic "ip_configuration" {
    for_each = var.ip_configuration != null ? [var.ip_configuration] : []
    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = ip_configuration.value.subresource_name
      member_name        = ip_configuration.value.member_name
    }
  }

  private_dns_zone_group {
    name                 = var.private_dns_zone_group.name
    private_dns_zone_ids = var.private_dns_zone_group.private_dns_zone_ids
  }

}

