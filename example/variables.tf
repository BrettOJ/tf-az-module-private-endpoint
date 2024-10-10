
variable "location" {
  type        = string
  description = "(optional) describe your variable"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
}

variable "custom_network_interface_name" {
  type        = string
  description = "(Optional) The custom name of the network interface attached to the private endpoint. Changing this forces a new resource to be created."
}

variable "private_service_connection_name" {
  type        = string
  description = "(Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created."
}

variable "private_service_connection_private_connection_resource_id" {
  type        = string
  description = "(Required) Specifies the ID of the Private Connection Resource to connect to. Changing this forces a new resource to be created."
}

variable "private_service_connection_is_manual_connection" {
  type        = bool
  description = "(Optional) Specifies whether the connection is manual or automatic. Defaults to false."
}

variable "private_service_connection_private_connection_resource_alias" {
  type        = string
  description = "(Optional) Specifies the Alias of the Private Connection Resource to connect to."
}

variable "private_service_connection_subresource_name" {
  type        = list(string)
  description = "(Optional) Specifies the list of Subresource Names to include within the private_service_connection."
}

variable "private_service_connection_request_message" {
  type        = string
  description = "(Optional) Specifies the Request Message to include within the private_service_connection."
}

variable "ip_configuration_name" {
  type        = string
  description = "(Required) Specifies the Name of the IP Configuration. Changing this forces a new resource to be created."
}

variable "ip_configuration_private_ip_address" {
  type        = string
  description = "(Optional) Specifies the Private IP Address to include within the ip_configuration."
}

variable "ip_configuration_subresource_name" {
  type        = string
  description = "(Optional) Specifies the Subresource Name to include within the ip_configuration."
}

variable "ip_configuration_member_name" {
  type        = string
  description = "(Optional) Specifies the Member Name to include within the ip_configuration."
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "(Required) Specifies the Name of the Private DNS Zone Group. Changing this forces a new resource to be created."
}

variable "private_dns_zone_group_private_dns_zone_ids" {
  type        = string
  description = "(Required) Specifies the ID of the Private DNS Zone to connect to. Changing this forces a new resource to be created."
}
