locals {
  naming_convention_info = {
    project_code = "project_code"
    env         = "env"
    zone         = "zone"
    tier         = "tier"
    name         = "name"
    agency_code  = "acS"
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

module "azure_storage_account" {
  source                 = "git::https://github.com/BrettOJ/tf-az-module-azure-storage-account?ref=main"
  resource_group_name    = module.resource_groups.rg_output[1].name
  location               = var.location
  account_kind           = "StorageV2"
  account_tier           = "Standard"
  min_tls_version        = "TLS1_2"
  tags                   = local.tags
  naming_convention_info = local.naming_convention_info
  share_properties       = null
}



module "azure_virtual_network" {
  source                 = "git::https://github.com/BrettOJ/tf-az-module-virtual-network?ref=main"
  location               = var.location
  resource_group_name    = module.resource_groups.rg_output[1].name
  address_space          = var.address_space
  dns_servers            = var.dns_servers
  naming_convention_info = local.naming_convention_info
  tags                   = local.tags

}

module "azure_subnet" {
  source                 = "git::https://github.com/BrettOJ/tf-az-module-network-subnet?ref=main"
  resource_group_name    = module.resource_groups.rg_output[1].name
  virtual_network_name   = module.azure_virtual_network.vnets_output.name
  location               = var.location
  naming_convention_info = local.naming_convention_info
  tags                   = local.tags
  create_nsg             = var.create_nsg
  subnets = {
    001 = {
      address_prefixes                          = ["10.0.1.0/24"]
      service_endpoints                         = null
      private_endpoint_network_policies_enabled = null
      route_table_id                            = null
      delegation                                = null
      nsg_inbound                               = []
      nsg_outbound                              = []
    }
  }
}

module "azure_private_endpoint" {
  source = "../" #"git::https://github.com/BrettOJ/tf-az-module-private-endpoint?ref=main"

  location                      = var.location
  resource_group_name           = module.resource_groups.rg_output[1].name
  subnet_id                     = module.azure_subnet.snet_output[1].id
  custom_network_interface_name = var.custom_network_interface_name
  tags                          = local.tags
  naming_convention_info        = local.naming_convention_info
  ip_configuration = null

  private_service_connection = {
    name                              = var.private_service_connection_name
    private_connection_resource_id    = module.azure_storage_account.sst_output.id
    is_manual_connection              = var.private_service_connection_is_manual_connection
    private_connection_resource_alias = var.private_service_connection_private_connection_resource_alias
    subresource_names                 = var.private_service_connection_subresource_names
    request_message                   = var.private_service_connection_request_message
  }

  private_dns_zone_group = {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = [var.private_dns_zone_group_private_dns_zone_ids]
  }

}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = module.resource_groups.rg_output[1].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "example-link"
  resource_group_name   = module.resource_groups.rg_output[1].name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = module.azure_virtual_network.vnets_output.id
}