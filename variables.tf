# Variables for AWS Hybrid Connectivity Module

# Common Variables
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID for the hybrid connectivity setup"
  type        = string
}

# Transit Gateway Variables
variable "create_transit_gateway" {
  description = "Whether to create a Transit Gateway"
  type        = bool
  default     = true
}

variable "transit_gateway_name" {
  description = "Name of the Transit Gateway"
  type        = string
  default     = "main-transit-gateway"
}

variable "transit_gateway_description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Main Transit Gateway for hybrid connectivity"
}

variable "transit_gateway_asn" {
  description = "Private Autonomous System Number (ASN) for the Transit Gateway"
  type        = number
  default     = 64512
}

variable "transit_gateway_default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_default_route_table_association)
    error_message = "Must be either 'enable' or 'disable'."
  }
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_default_route_table_propagation)
    error_message = "Must be either 'enable' or 'disable'."
  }
}

variable "transit_gateway_auto_accept_shared_attachments" {
  description = "Whether resource attachments are automatically accepted"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_auto_accept_shared_attachments)
    error_message = "Must be either 'enable' or 'disable'."
  }
}

variable "transit_gateway_dns_support" {
  description = "Whether DNS support is enabled"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_dns_support)
    error_message = "Must be either 'enable' or 'disable'."
  }
}

variable "transit_gateway_vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_vpn_ecmp_support)
    error_message = "Must be either 'enable' or 'disable'."
  }
}

variable "transit_gateway_multicast_support" {
  description = "Whether multicast support is enabled"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_multicast_support)
    error_message = "Must be either 'enable' or 'disable'."
  }
}

# Transit Gateway Route Table Variables
variable "create_transit_gateway_route_table" {
  description = "Whether to create a Transit Gateway route table"
  type        = bool
  default     = true
}

variable "transit_gateway_route_table_name" {
  description = "Name of the Transit Gateway route table"
  type        = string
  default     = "main-tgw-route-table"
}

variable "create_transit_gateway_route_table_association" {
  description = "Whether to create Transit Gateway route table association"
  type        = bool
  default     = true
}

variable "create_transit_gateway_route_table_propagation" {
  description = "Whether to create Transit Gateway route table propagation"
  type        = bool
  default     = true
}

# Direct Connect Gateway Variables
variable "create_direct_connect_gateway" {
  description = "Whether to create a Direct Connect Gateway"
  type        = bool
  default     = false
}

variable "direct_connect_gateway_name" {
  description = "Name of the Direct Connect Gateway"
  type        = string
  default     = "main-dx-gateway"
}

variable "direct_connect_gateway_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of a BGP session"
  type        = number
  default     = 64512
}

variable "create_direct_connect_gateway_association" {
  description = "Whether to create Direct Connect Gateway association with Transit Gateway"
  type        = bool
  default     = false
}

variable "direct_connect_allowed_prefixes" {
  description = "VPC prefixes (CIDRs) to advertise to the Direct Connect Gateway"
  type        = list(string)
  default     = []
}

# Customer Gateway Variables
variable "create_customer_gateway" {
  description = "Whether to create a Customer Gateway"
  type        = bool
  default     = false
}

variable "customer_gateway_name" {
  description = "Name of the Customer Gateway"
  type        = string
  default     = "main-customer-gateway"
}

variable "customer_gateway_bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)"
  type        = number
  default     = 65000
}

variable "customer_gateway_ip_address" {
  description = "The IP address of the gateway's Internet-routable external interface"
  type        = string
  default     = ""
}

# VPN Gateway Variables
variable "create_vpn_gateway" {
  description = "Whether to create a VPN Gateway"
  type        = bool
  default     = false
}

variable "vpn_gateway_name" {
  description = "Name of the VPN Gateway"
  type        = string
  default     = "main-vpn-gateway"
}

# VPN Connection Variables
variable "create_vpn_connection" {
  description = "Whether to create a VPN Connection"
  type        = bool
  default     = false
}

variable "vpn_connection_name" {
  description = "Name of the VPN Connection"
  type        = string
  default     = "main-vpn-connection"
}

variable "vpn_static_routes_only" {
  description = "Whether the VPN connection uses static routes exclusively"
  type        = bool
  default     = false
}

variable "vpn_static_routes" {
  description = "List of CIDR blocks for static routes"
  type        = list(string)
  default     = []
}

variable "vpn_tunnel1_preshared_key" {
  description = "The preshared key of the first VPN tunnel"
  type        = string
  default     = ""
  sensitive   = true
}

variable "vpn_tunnel2_preshared_key" {
  description = "The preshared key of the second VPN tunnel"
  type        = string
  default     = ""
  sensitive   = true
}

# VPN Connection Logging Variables
variable "enable_vpn_connection_logging" {
  description = "Whether to enable VPN connection logging to CloudWatch"
  type        = bool
  default     = false
}

variable "vpn_connection_log_retention_days" {
  description = "Number of days to retain VPN connection logs"
  type        = number
  default     = 7
}

# Transit Gateway VPC Attachment Variables
variable "create_transit_gateway_vpc_attachment" {
  description = "Whether to create a Transit Gateway VPC attachment"
  type        = bool
  default     = true
}

variable "transit_gateway_subnet_ids" {
  description = "List of subnet IDs for the Transit Gateway VPC attachment"
  type        = list(string)
  default     = []
}

variable "transit_gateway_vpc_attachment_name" {
  description = "Name of the Transit Gateway VPC attachment"
  type        = string
  default     = "main-tgw-vpc-attachment"
}

variable "transit_gateway_appliance_mode_support" {
  description = "Whether Appliance Mode support is enabled"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_appliance_mode_support)
    error_message = "Must be either 'enable' or 'disable'."
  }
}

variable "transit_gateway_ipv6_support" {
  description = "Whether IPv6 support is enabled"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_ipv6_support)
    error_message = "Must be either 'enable' or 'disable'."
  }
}

# Route Table Variables
variable "transit_gateway_routes" {
  description = "List of routes to add to the Transit Gateway route table"
  type = list(object({
    cidr_block = string
  }))
  default = []
}

variable "transit_gateway_route_table_subnet_ids" {
  description = "List of subnet IDs to associate with the Transit Gateway route table"
  type        = list(string)
  default     = []
} 