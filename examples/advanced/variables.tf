# Variables for Advanced Transit Gateway Example
# Enhanced with comprehensive enterprise configuration options

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "VPC ID for the hybrid connectivity setup"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "hybrid-connectivity"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "enterprise-ops"
}

variable "cost_center" {
  description = "Cost center for billing purposes"
  type        = string
  default     = "enterprise-infrastructure"
}

variable "data_classification" {
  description = "Data classification level"
  type        = string
  default     = "confidential"
}

variable "compliance_requirements" {
  description = "Compliance requirements (e.g., SOC2, HIPAA, PCI)"
  type        = string
  default     = "SOC2"
}

# ==============================================================================
# Transit Gateway Configuration
# ==============================================================================

variable "transit_gateway_asn" {
  description = "Private Autonomous System Number (ASN) for the Transit Gateway"
  type        = number
  default     = 64512
}

variable "enable_multicast" {
  description = "Whether to enable multicast support on Transit Gateway"
  type        = bool
  default     = false
}

variable "enable_appliance_mode" {
  description = "Whether to enable appliance mode on VPC attachment"
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Whether to enable IPv6 support on VPC attachment"
  type        = bool
  default     = false
}

# ==============================================================================
# Direct Connect Configuration
# ==============================================================================

variable "enable_direct_connect" {
  description = "Whether to enable Direct Connect"
  type        = bool
  default     = true
}

variable "direct_connect_gateway_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of a BGP session"
  type        = number
  default     = 64512
}

variable "direct_connect_allowed_prefixes" {
  description = "VPC prefixes (CIDRs) to advertise to the Direct Connect Gateway"
  type        = list(string)
  default     = ["10.0.0.0/16", "172.16.0.0/12"]
}

# ==============================================================================
# VPN Configuration
# ==============================================================================

variable "enable_vpn" {
  description = "Whether to enable VPN connection"
  type        = bool
  default     = true
}

variable "primary_vpn_ip" {
  description = "Primary VPN device IP address"
  type        = string
  default     = "203.0.113.1"
}

variable "customer_gateway_bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)"
  type        = number
  default     = 65000
}

variable "customer_gateway_ip_address" {
  description = "The IP address of the gateway's Internet-routable external interface"
  type        = string
  default     = "203.0.113.1"
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

variable "primary_vpn_tunnel1_preshared_key" {
  description = "The preshared key of the first VPN tunnel"
  type        = string
  default     = ""
  sensitive   = true
}

variable "primary_vpn_tunnel2_preshared_key" {
  description = "The preshared key of the second VPN tunnel"
  type        = string
  default     = ""
  sensitive   = true
}

variable "vpn_tunnel1_preshared_key" {
  description = "The preshared key of the first VPN tunnel (legacy)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "vpn_tunnel2_preshared_key" {
  description = "The preshared key of the second VPN tunnel (legacy)"
  type        = string
  default     = ""
  sensitive   = true
}

# ==============================================================================
# VPN Logging Configuration
# ==============================================================================

variable "enable_vpn_logging" {
  description = "Whether to enable VPN connection logging to CloudWatch"
  type        = bool
  default     = true
}

variable "vpn_log_retention_days" {
  description = "Number of days to retain VPN connection logs"
  type        = number
  default     = 30
}

# ==============================================================================
# Route Configuration
# ==============================================================================

variable "transit_gateway_routes" {
  description = "List of routes to add to the Transit Gateway route table"
  type = list(object({
    cidr_block = string
  }))
  default = [
    {
      cidr_block = "10.0.0.0/16"
    },
    {
      cidr_block = "172.16.0.0/12"
    }
  ]
}

# ==============================================================================
# Enterprise Features Configuration
# ==============================================================================

variable "enable_backup" {
  description = "Whether to enable backup features"
  type        = bool
  default     = true
}

variable "enable_disaster_recovery" {
  description = "Whether to enable disaster recovery features"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_insights" {
  description = "Whether to enable CloudWatch Insights"
  type        = bool
  default     = false
}

variable "enable_anomaly_detection" {
  description = "Whether to enable CloudWatch anomaly detection"
  type        = bool
  default     = false
}

variable "enable_compliance" {
  description = "Whether to enable compliance features"
  type        = bool
  default     = true
}

variable "enable_governance" {
  description = "Whether to enable governance features"
  type        = bool
  default     = true
}

variable "enable_privacy" {
  description = "Whether to enable privacy features"
  type        = bool
  default     = true
} 