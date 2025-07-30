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

# ==============================================================================
# Enhanced Hybrid Connectivity Configuration Variables
# ==============================================================================

variable "hybrid_config" {
  description = "Hybrid connectivity configuration"
  type = object({
    enable_transit_gateway = optional(bool, true)
    enable_direct_connect = optional(bool, false)
    enable_vpn_connectivity = optional(bool, true)
    enable_customer_gateway = optional(bool, true)
    enable_vpn_gateway = optional(bool, true)
    enable_vpc_attachment = optional(bool, true)
    enable_route_tables = optional(bool, true)
    enable_route_propagation = optional(bool, true)
    enable_route_association = optional(bool, true)
    enable_multicast = optional(bool, false)
    enable_dns_support = optional(bool, true)
    enable_vpn_ecmp = optional(bool, true)
    enable_auto_accept = optional(bool, false)
    enable_logging = optional(bool, true)
    enable_monitoring = optional(bool, true)
    enable_metrics = optional(bool, true)
    enable_alerts = optional(bool, true)
    enable_dashboard = optional(bool, true)
    enable_audit = optional(bool, true)
    enable_backup = optional(bool, false)
    enable_disaster_recovery = optional(bool, false)
  })
  default = {}
}

variable "transit_gateways" {
  description = "Map of Transit Gateways to create"
  type = map(object({
    name = string
    description = optional(string, null)
    amazon_side_asn = optional(number, 64512)
    auto_accept_shared_attachments = optional(string, "disable")
    default_route_table_association = optional(string, "enable")
    default_route_table_propagation = optional(string, "enable")
    dns_support = optional(string, "enable")
    multicast_support = optional(string, "disable")
    vpn_ecmp_support = optional(string, "enable")
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "transit_gateway_route_tables" {
  description = "Map of Transit Gateway Route Tables to create"
  type = map(object({
    transit_gateway_id = string
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "transit_gateway_route_table_associations" {
  description = "Map of Transit Gateway Route Table Associations to create"
  type = map(object({
    transit_gateway_attachment_id = string
    transit_gateway_route_table_id = string
  }))
  default = {}
}

variable "transit_gateway_route_table_propagations" {
  description = "Map of Transit Gateway Route Table Propagations to create"
  type = map(object({
    transit_gateway_attachment_id = string
    transit_gateway_route_table_id = string
  }))
  default = {}
}

variable "transit_gateway_vpc_attachments" {
  description = "Map of Transit Gateway VPC Attachments to create"
  type = map(object({
    transit_gateway_id = string
    vpc_id = string
    subnet_ids = list(string)
    appliance_mode_support = optional(string, "disable")
    dns_support = optional(string, "enable")
    ipv6_support = optional(string, "disable")
    transit_gateway_default_route_table_association = optional(bool, true)
    transit_gateway_default_route_table_propagation = optional(bool, true)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "transit_gateway_peering_attachments" {
  description = "Map of Transit Gateway Peering Attachments to create"
  type = map(object({
    peer_transit_gateway_id = string
    transit_gateway_id = string
    peer_account_id = optional(string, null)
    peer_region = string
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "transit_gateway_peering_attachment_accepter" {
  description = "Map of Transit Gateway Peering Attachment Accepters to create"
  type = map(object({
    transit_gateway_attachment_id = string
    transit_gateway_default_route_table_association = optional(bool, true)
    transit_gateway_default_route_table_propagation = optional(bool, true)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "transit_gateway_routes" {
  description = "Map of Transit Gateway Routes to create"
  type = map(object({
    destination_cidr_block = string
    transit_gateway_attachment_id = string
    transit_gateway_route_table_id = string
  }))
  default = {}
}

variable "direct_connect_gateways" {
  description = "Map of Direct Connect Gateways to create"
  type = map(object({
    name = string
    amazon_side_asn = optional(number, 64512)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "direct_connect_gateway_associations" {
  description = "Map of Direct Connect Gateway Associations to create"
  type = map(object({
    dx_gateway_id = string
    transit_gateway_id = string
    allowed_prefixes = optional(list(string), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "customer_gateways" {
  description = "Map of Customer Gateways to create"
  type = map(object({
    bgp_asn = number
    ip_address = string
    certificate_arn = optional(string, null)
    device_name = optional(string, null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "vpn_gateways" {
  description = "Map of VPN Gateways to create"
  type = map(object({
    vpc_id = string
    availability_zone = optional(string, null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "vpn_connections" {
  description = "Map of VPN Connections to create"
  type = map(object({
    customer_gateway_id = string
    transit_gateway_id = optional(string, null)
    vpn_gateway_id = optional(string, null)
    static_routes_only = optional(bool, false)
    tunnel1_preshared_key = optional(string, null)
    tunnel2_preshared_key = optional(string, null)
    tunnel1_inside_ipv4_cidr = optional(string, null)
    tunnel2_inside_ipv4_cidr = optional(string, null)
    tunnel1_inside_ipv6_cidr = optional(string, null)
    tunnel2_inside_ipv6_cidr = optional(string, null)
    enable_acceleration = optional(bool, false)
    local_ipv4_network_cidr = optional(string, null)
    remote_ipv4_network_cidr = optional(string, null)
    local_ipv6_network_cidr = optional(string, null)
    remote_ipv6_network_cidr = optional(string, null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "vpn_connection_routes" {
  description = "Map of VPN Connection Routes to create"
  type = map(object({
    destination_cidr_block = string
    vpn_connection_id = string
  }))
  default = {}
}

variable "vpn_gateway_route_propagations" {
  description = "Map of VPN Gateway Route Propagations to create"
  type = map(object({
    route_table_id = string
    vpn_gateway_id = string
  }))
  default = {}
}

variable "vpn_gateway_attachments" {
  description = "Map of VPN Gateway Attachments to create"
  type = map(object({
    vpc_id = string
    vpn_gateway_id = string
  }))
  default = {}
}

variable "hybrid_monitoring_config" {
  description = "Hybrid connectivity monitoring configuration"
  type = object({
    enable_cloudwatch_monitoring = optional(bool, true)
    enable_cloudwatch_logs = optional(bool, true)
    enable_cloudwatch_metrics = optional(bool, true)
    enable_cloudwatch_alarms = optional(bool, true)
    enable_cloudwatch_dashboard = optional(bool, true)
    enable_cloudwatch_insights = optional(bool, false)
    enable_cloudwatch_anomaly_detection = optional(bool, false)
    enable_cloudwatch_rum = optional(bool, false)
    enable_cloudwatch_evidently = optional(bool, false)
    enable_cloudwatch_application_signals = optional(bool, false)
    enable_cloudwatch_synthetics = optional(bool, false)
    enable_cloudwatch_contributor_insights = optional(bool, false)
    enable_cloudwatch_metric_streams = optional(bool, false)
    enable_cloudwatch_metric_filters = optional(bool, false)
    enable_cloudwatch_log_groups = optional(bool, true)
    enable_cloudwatch_log_streams = optional(bool, true)
    enable_cloudwatch_log_subscriptions = optional(bool, false)
    enable_cloudwatch_log_insights = optional(bool, false)
    enable_cloudwatch_log_metric_filters = optional(bool, false)
    enable_cloudwatch_log_destinations = optional(bool, false)
    enable_cloudwatch_log_queries = optional(bool, false)
    enable_cloudwatch_log_analytics = optional(bool, false)
    enable_cloudwatch_log_visualization = optional(bool, false)
    enable_cloudwatch_log_reporting = optional(bool, false)
    enable_cloudwatch_log_archiving = optional(bool, false)
    enable_cloudwatch_log_backup = optional(bool, false)
    enable_cloudwatch_log_retention = optional(bool, true)
    enable_cloudwatch_log_encryption = optional(bool, true)
    enable_cloudwatch_log_access_logging = optional(bool, false)
    enable_cloudwatch_log_audit_logging = optional(bool, false)
    enable_cloudwatch_log_compliance_logging = optional(bool, false)
    enable_cloudwatch_log_security_logging = optional(bool, false)
    enable_cloudwatch_log_performance_logging = optional(bool, true)
    enable_cloudwatch_log_business_logging = optional(bool, false)
    enable_cloudwatch_log_operational_logging = optional(bool, true)
    enable_cloudwatch_log_debug_logging = optional(bool, false)
    enable_cloudwatch_log_trace_logging = optional(bool, false)
    enable_cloudwatch_log_error_logging = optional(bool, true)
    enable_cloudwatch_log_warning_logging = optional(bool, true)
    enable_cloudwatch_log_info_logging = optional(bool, true)
    enable_cloudwatch_log_debug_logging = optional(bool, false)
    enable_cloudwatch_log_verbose_logging = optional(bool, false)
    enable_cloudwatch_log_silent_logging = optional(bool, false)
  })
  default = {}
}

variable "hybrid_security_config" {
  description = "Hybrid connectivity security configuration"
  type = object({
    enable_encryption = optional(bool, true)
    enable_access_control = optional(bool, true)
    enable_audit_logging = optional(bool, true)
    enable_compliance = optional(bool, false)
    enable_governance = optional(bool, false)
    enable_privacy = optional(bool, false)
    enable_fairness = optional(bool, false)
    enable_bias_detection = optional(bool, false)
    enable_explainability = optional(bool, false)
    enable_interpretability = optional(bool, false)
    enable_robustness = optional(bool, false)
    enable_adversarial_protection = optional(bool, false)
    enable_poisoning_protection = optional(bool, false)
    enable_extraction_protection = optional(bool, false)
    enable_inversion_protection = optional(bool, false)
    enable_membership_inference_protection = optional(bool, false)
    enable_model_inversion_protection = optional(bool, false)
    enable_attribute_inference_protection = optional(bool, false)
    enable_property_inference_protection = optional(bool, false)
    enable_reconstruction_protection = optional(bool, false)
    enable_extraction_protection = optional(bool, false)
    enable_stealing_protection = optional(bool, false)
    enable_evasion_protection = optional(bool, false)
    enable_poisoning_protection = optional(bool, false)
    enable_backdoor_protection = optional(bool, false)
    enable_trojan_protection = optional(bool, false)
    enable_trigger_protection = optional(bool, false)
  })
  default = {}
} 