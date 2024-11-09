
variable "location" {
  type        = string
  description = "(optional) describe your variable"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
}

variable "custom_network_interface_name" {
  type        = string
  description = "(Optional) The custom name of the network interface attached to the private endpoint. Changing this forces a new resource to be created."
}

variable "private_service_connection_name" {
  type        = string
  description = "(Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created."
}

variable "private_service_connection_is_manual_connection" {
  type        = bool
  description = "(Optional) Specifies whether the connection is manual or automatic. Defaults to false."
}

variable "private_service_connection_private_connection_resource_alias" {
  type        = string
  description = "(Optional) Specifies the Alias of the Private Connection Resource to connect to."
  default = null
}

variable "private_service_connection_subresource_names" {
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
  default     = null
}

variable "ip_configuration_private_ip_address" {
  type        = string
  description = "(Optional) Specifies the Private IP Address to include within the ip_configuration."
  default     = null
}

variable "ip_configuration_subresource_name" {
  type        = string
  description = "(Optional) Specifies the Subresource Name to include within the ip_configuration."
  default     = null
}

variable "ip_configuration_member_name" {
  type        = string
  description = "(Optional) Specifies the Member Name to include within the ip_configuration."
  default     = null
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "(Required) Specifies the Name of the Private DNS Zone Group. Changing this forces a new resource to be created."
}


variable "create_nsg" {
  type        = bool
  description = "(Optional) Specifies whether to create a Network Security Group for the Subnet. Defaults to false."
  default = false
  
}

variable "address_space" {
  type        = list(string)
  description = "(Required) Specifies the Address Space that should be used for the Virtual Network. Changing this forces a new resource to be created."  
}

variable "dns_servers" {
  type        = list(string)
  description = "(Optional) Specifies the DNS Servers that should be used for the Virtual Network. Changing this forces a new resource to be created."
  default     = null
}

variable "domain_name" {
  type = string
  description = "(Optional) Specifies the Domain Name that should be used for the Private DNS Zone. Changing this forces a new resource to be created."
}

