
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

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "private_dns_zone_group" {
  type = object({
    name                 = string
    private_dns_zone_ids = list(string)
  })
  description = "(Optional) Specifies the list of Private DNS Zones to include within the private_dns_zone_group."
}

variable "private_service_connection" {
  type = object({
    name                              = string
    is_manual_connection              = bool
    private_connection_resource_id    = string
    private_connection_resource_alias = string
    subresource_names                 = list(string)
    request_message                   = string
  })
  description = "(Optional) Specifies the list of Private Service Connections to include within the private_service_connection."
}

variable "ip_configuration" {
  type = object({
    name               = string
    private_ip_address = string
    subresource_name   = string
    member_name        = string
  })
  description = "(Optional) Specifies the list of IP Configurations to include within the ip_configuration."
  default     = null
}

variable "naming_convention_info" {
  type = object({
    env          = string
    zone         = string
    app         = string
    name         = string
  })
  description = "(Optional) Specifies the naming convention for the resource."
}

variable "name" {
  type        = string
  description = "(Required) Specifies the type of the Private Endpoint. Changing this forces a new resource to be created."
}