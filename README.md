Manages a Private Endpoint.

Azure Private Endpoint is a network interface that connects you privately and securely to a service powered by Azure Private Link. Private Endpoint uses a private IP address from your VNet, effectively bringing the service into your VNet. The service could be an Azure service such as Azure Storage, SQL, etc. or your own Private Link Service.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#example-usage)

```hcl
resource "azurerm_resource_group" "example" { name = "example-resources" location = "West Europe" } resource "azurerm_virtual_network" "example" { name = "example-network" address_space = ["10.0.0.0/16"] location = azurerm_resource_group.example.location resource_group_name = azurerm_resource_group.example.name } resource "azurerm_subnet" "service" { name = "service" resource_group_name = azurerm_resource_group.example.name virtual_network_name = azurerm_virtual_network.example.name address_prefixes = ["10.0.1.0/24"] enforce_private_link_service_network_policies = true } resource "azurerm_subnet" "endpoint" { name = "endpoint" resource_group_name = azurerm_resource_group.example.name virtual_network_name = azurerm_virtual_network.example.name address_prefixes = ["10.0.2.0/24"] enforce_private_link_endpoint_network_policies = true } resource "azurerm_public_ip" "example" { name = "example-pip" sku = "Standard" location = azurerm_resource_group.example.location resource_group_name = azurerm_resource_group.example.name allocation_method = "Static" } resource "azurerm_lb" "example" { name = "example-lb" sku = "Standard" location = azurerm_resource_group.example.location resource_group_name = azurerm_resource_group.example.name frontend_ip_configuration { name = azurerm_public_ip.example.name public_ip_address_id = azurerm_public_ip.example.id } } resource "azurerm_private_link_service" "example" { name = "example-privatelink" location = azurerm_resource_group.example.location resource_group_name = azurerm_resource_group.example.name nat_ip_configuration { name = azurerm_public_ip.example.name primary = true subnet_id = azurerm_subnet.service.id } load_balancer_frontend_ip_configuration_ids = [ azurerm_lb.example.frontend_ip_configuration[0].id, ] } resource "azurerm_private_endpoint" "example" { name = "example-endpoint" location = azurerm_resource_group.example.location resource_group_name = azurerm_resource_group.example.name subnet_id = azurerm_subnet.endpoint.id private_service_connection { name = "example-privateserviceconnection" private_connection_resource_id = azurerm_private_link_service.example.id is_manual_connection = false } }
```

Using a Private Link Service Alias with existing resources:

```hcl
data "azurerm_resource_group" "example" { name = "example-resources" } data "azurerm_virtual_network" "vnet" { name = "example-network" resource_group_name = data.azurerm_resource_group.example.name } data "azurerm_subnet" "subnet" { name = "default" virtual_network_name = data.azurerm_virtual_network.vnet.name resource_group_name = data.azurerm_resource_group.example.name } resource "azurerm_private_endpoint" "example" { name = "example-endpoint" location = data.azurerm_resource_group.example.location resource_group_name = data.azurerm_resource_group.example.name subnet_id = data.azurerm_subnet.subnet.id private_service_connection { name = "example-privateserviceconnection" private_connection_resource_alias = "example-privatelinkservice.d20286c8-4ea5-11eb-9584-8f53157226c6.centralus.azure.privatelinkservice" is_manual_connection = true request_message = "PL" } }
```

Using a Private Endpoint pointing to an _owned_ Azure service, with proper DNS configuration:

```hcl
resource "azurerm_resource_group" "example" { name = "example-rg" location = "West Europe" } resource "azurerm_storage_account" "example" { name = "exampleaccount" resource_group_name = azurerm_resource_group.example.name location = azurerm_resource_group.example.location account_tier = "Standard" account_replication_type = "LRS" } resource "azurerm_virtual_network" "example" { name = "virtnetname" address_space = ["10.0.0.0/16"] location = azurerm_resource_group.example.location resource_group_name = azurerm_resource_group.example.name } resource "azurerm_subnet" "example" { name = "subnetname" resource_group_name = azurerm_resource_group.example.name virtual_network_name = azurerm_virtual_network.example.name address_prefixes = ["10.0.2.0/24"] } resource "azurerm_private_endpoint" "example" { name = "example-endpoint" location = azurerm_resource_group.example.location resource_group_name = azurerm_resource_group.example.name subnet_id = azurerm_subnet.example.id private_service_connection { name = "example-privateserviceconnection" private_connection_resource_id = azurerm_storage_account.example.id subresource_names = ["blob"] is_manual_connection = false } private_dns_zone_group { name = "example-dns-zone-group" private_dns_zone_ids = [azurerm_private_dns_zone.example.id] } } resource "azurerm_private_dns_zone" "example" { name = "privatelink.blob.core.windows.net" resource_group_name = azurerm_resource_group.example.name } resource "azurerm_private_dns_zone_virtual_network_link" "example" { name = "example-link" resource_group_name = azurerm_resource_group.example.name private_dns_zone_name = azurerm_private_dns_zone.example.name virtual_network_id = azurerm_virtual_network.example.id }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#argument-reference)

The following arguments are supported:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#name) - (Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created.
    
-   [`resource_group_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#resource_group_name) - (Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created.
    
-   [`location`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#location) - (Required) The supported Azure location where the resource exists. Changing this forces a new resource to be created.
    
-   [`subnet_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#subnet_id) - (Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.
    
-   [`custom_network_interface_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#custom_network_interface_name) - (Optional) The custom name of the network interface attached to the private endpoint. Changing this forces a new resource to be created.
    
-   [`private_dns_zone_group`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_dns_zone_group) - (Optional) A `private_dns_zone_group` block as defined below.
    
-   [`private_service_connection`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_service_connection) - (Required) A `private_service_connection` block as defined below.
    
-   [`ip_configuration`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#ip_configuration) - (Optional) One or more `ip_configuration` blocks as defined below. This allows a static IP address to be set for this Private Endpoint, otherwise an address is dynamically allocated from the Subnet.
    
-   [`tags`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#tags) - (Optional) A mapping of tags to assign to the resource.
    

___

A `private_dns_zone_group` block supports the following:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#name) - (Required) Specifies the Name of the Private DNS Zone Group.
    
-   [`private_dns_zone_ids`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_dns_zone_ids) - (Required) Specifies the list of Private DNS Zones to include within the `private_dns_zone_group`.
    

___

A `private_service_connection` block supports the following:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#name) - (Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created.
    
-   [`is_manual_connection`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#is_manual_connection) - (Required) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created.
    

-   [`private_connection_resource_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_connection_resource_id) - (Optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of `private_connection_resource_id` or `private_connection_resource_alias` must be specified. Changing this forces a new resource to be created. For a web app or function app slot, the parent web app should be used in this field instead of a reference to the slot itself.
    
-   [`private_connection_resource_alias`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_connection_resource_alias) - (Optional) The Service Alias of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of `private_connection_resource_id` or `private_connection_resource_alias` must be specified. Changing this forces a new resource to be created.
    
-   [`subresource_names`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#subresource_names) - (Optional) A list of subresource names which the Private Endpoint is able to connect to. `subresource_names` corresponds to `group_id`. Possible values are detailed in the product [documentation](https://docs.microsoft.com/azure/private-link/private-endpoint-overview#private-link-resource) in the `Subresources` column. Changing this forces a new resource to be created.
    

-   [`request_message`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#request_message) - (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The provider allows a maximum request message length of `140` characters, however the request message maximum length is dependent on the service the private endpoint is connected to. Only valid if `is_manual_connection` is set to `true`.

___

An `ip_configuration` block supports the following:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#name) - (Required) Specifies the Name of the IP Configuration. Changing this forces a new resource to be created.
    
-   [`private_ip_address`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_ip_address) - (Required) Specifies the static IP address within the private endpoint's subnet to be used. Changing this forces a new resource to be created.
    
-   [`subresource_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#subresource_name) - (Optional) Specifies the subresource this IP address applies to. `subresource_names` corresponds to `group_id`. Changing this forces a new resource to be created.
    
-   [`member_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#member_name) - (Optional) Specifies the member name this IP address applies to. If it is not specified, it will use the value of `subresource_name`. Changing this forces a new resource to be created.
    

## [Attributes Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#attributes-reference)

In addition to the Arguments listed above - the following Attributes are exported:

-   [`id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#id) - The ID of the Private Endpoint.
    
-   [`network_interface`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#network_interface) - A `network_interface` block as defined below.
    
-   [`custom_dns_configs`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#custom_dns_configs) - A `custom_dns_configs` block as defined below.
    
-   [`private_dns_zone_configs`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_dns_zone_configs) - A `private_dns_zone_configs` block as defined below.
    
-   [`ip_configuration`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#ip_configuration) - A `ip_configuration` block as defined below.
    

___

A `network_interface` block exports:

-   [`id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#id) - The ID of the network interface associated with the `private_endpoint`.
    
-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#name) - The name of the network interface associated with the `private_endpoint`.
    

___

A `private_dns_zone_group` block exports:

-   [`id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#id) - The ID of the Private DNS Zone Group.

___

A `custom_dns_configs` block exports:

-   [`fqdn`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#fqdn) - The fully qualified domain name to the `private_endpoint`.
    
-   [`ip_addresses`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#ip_addresses) - A list of all IP Addresses that map to the `private_endpoint` fqdn.
    

___

A `private_dns_zone_configs` block exports:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#name) - The name of the Private DNS Zone that the config belongs to.
    
-   [`id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#id) - The ID of the Private DNS Zone Config.
    
-   [`private_dns_zone_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_dns_zone_id) - A list of IP Addresses
    
-   [`record_sets`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#record_sets) - A `record_sets` block as defined below.
    

___

A `private_service_connection` block exports:

-   [`private_ip_address`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_ip_address) - (Computed) The private IP address associated with the private endpoint, note that you will have a private IP address assigned to the private endpoint even if the connection request was `Rejected`.

___

An `ip_configuration` block exports:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#name) - (Required) The Name of the IP Configuration.
    
-   [`private_ip_address`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#private_ip_address) - (Required) The static IP address set by this configuration. It is recommended to use the private IP address exported in the `private_service_connection` block to obtain the address associated with the private endpoint.
    
-   [`subresource_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#subresource_name) - (Required) The subresource this IP address applies to, which corresponds to the `group_id`.
    

___

A `record_sets` block exports:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#name) - The name of the Private DNS Zone that the config belongs to.
    
-   [`type`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#type) - The type of DNS record.
    
-   [`fqdn`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#fqdn) - The fully qualified domain name to the `private_dns_zone`.
    
-   [`ttl`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#ttl) - The time to live for each connection to the `private_dns_zone`.
    
-   [`ip_addresses`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#ip_addresses) - A list of all IP Addresses that map to the `private_dns_zone` fqdn.
    

___

## [Example HCL Configurations](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#example-hcl-configurations)

-   How to connect a `Private Endpoint` to a [Application Gateway](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/private-endpoint/application-gateway)
-   How to connect a `Private Endpoint` to a [Cosmos MongoDB](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/private-endpoint/cosmos-db/mongodb)
-   How to connect a `Private Endpoint` to a [Cosmos PostgreSQL](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/private-endpoint/cosmos-db/postgresql)
-   How to connect a `Private Endpoint` to a [PostgreSQL Server](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/private-endpoint/postgresql)
-   How to connect a `Private Endpoint` to a [Private Link Service](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/private-endpoint/private-link-service)
-   How to connect a `Private Endpoint` to a [Private DNS Group](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/private-endpoint/private-dns-group)
-   How to connect a `Private Endpoint` to a [Databricks Workspace](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/private-endpoint/databricks)

## [Timeouts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#timeouts)

The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:

-   [`create`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#create) - (Defaults to 60 minutes) Used when creating the Private Endpoint.
-   [`update`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#update) - (Defaults to 60 minutes) Used when updating the Private Endpoint.
-   [`read`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#read) - (Defaults to 5 minutes) Used when retrieving the Private Endpoint.
-   [`delete`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#delete) - (Defaults to 60 minutes) Used when deleting the Private Endpoint.

## [Import](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#import)

Private Endpoints can be imported using the `resource id`, e.g.

```shell
terraform import azurerm_private_endpoint.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/group1/providers/Microsoft.Network/privateEndpoints/endpoint1
```