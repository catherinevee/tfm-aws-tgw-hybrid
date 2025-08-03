# Basic Transit Gateway Example
# This example demonstrates a simple Transit Gateway setup with VPC attachment
# Enhanced with comprehensive customization options

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source for existing VPC
data "aws_vpc" "main" {
  id = var.vpc_id
}

# Data source for existing subnets
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

# Enhanced Basic Transit Gateway Module
module "hybrid_connectivity" {
  source = "../../"

  # Required Configuration
  vpc_id = var.vpc_id

  # ==============================================================================
  # Transit Gateway Configuration
  # ==============================================================================
  
  # Basic Transit Gateway Settings
  create_transit_gateway = true
  transit_gateway_name   = "${var.environment}-tgw"
  transit_gateway_description = "Transit Gateway for ${var.environment} environment"
  
  # Advanced Transit Gateway Settings
  transit_gateway_asn = 64512 # Private ASN range (64512-65534)
  transit_gateway_default_route_table_association = "enable" # Automatically associate attachments
  transit_gateway_default_route_table_propagation = "enable" # Automatically propagate routes
  transit_gateway_auto_accept_shared_attachments = "disable" # Manual approval for shared attachments
  transit_gateway_dns_support = "enable" # Enable DNS resolution
  transit_gateway_vpn_ecmp_support = "enable" # Enable VPN Equal Cost Multipath
  transit_gateway_multicast_support = "disable" # Disable multicast (default)

  # ==============================================================================
  # VPC Attachment Configuration
  # ==============================================================================
  
  # VPC Attachment Settings
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = data.aws_subnets.private.ids # Must be in different AZs
  transit_gateway_vpc_attachment_name = "${var.environment}-tgw-vpc-attachment"
  
  # Advanced VPC Attachment Settings
  transit_gateway_appliance_mode_support = "disable" # Disable appliance mode
  transit_gateway_ipv6_support = "disable" # Disable IPv6 support

  # ==============================================================================
  # Route Table Configuration
  # ==============================================================================
  
  # Route Table Settings
  create_transit_gateway_route_table = true
  transit_gateway_route_table_name = "${var.environment}-tgw-route-table"
  transit_gateway_route_table_subnet_ids = data.aws_subnets.private.ids
  
  # Route Table Association and Propagation
  create_transit_gateway_route_table_association = true
  create_transit_gateway_route_table_propagation = true
  
  # Custom Routes (optional)
  transit_gateway_routes = [
    {
      cidr_block = "10.0.0.0/16" # Example route to another VPC
    }
  ]

  # ==============================================================================
  # VPN Configuration (Optional)
  # ==============================================================================
  
  # Customer Gateway (on-premises VPN device)
  create_customer_gateway = var.enable_vpn
  customer_gateway_name = "${var.environment}-customer-gateway"
  customer_gateway_bgp_asn = 65000 # Private ASN for on-premises device
  customer_gateway_ip_address = var.on_premises_vpn_ip # Public IP of on-premises VPN device
  
  # VPN Gateway
  create_vpn_gateway = var.enable_vpn
  vpn_gateway_name = "${var.environment}-vpn-gateway"
  
  # VPN Connection
  create_vpn_connection = var.enable_vpn
  vpn_connection_name = "${var.environment}-vpn-connection"
  vpn_static_routes_only = false # Use BGP for dynamic routing
  
  # VPN Security Configuration
  vpn_tunnel1_preshared_key = var.vpn_tunnel1_preshared_key
  vpn_tunnel2_preshared_key = var.vpn_tunnel2_preshared_key
  
  # VPN Tunnel Configuration
  vpn_tunnel1_dpd_timeout_action = "restart" # Restart tunnel on DPD timeout
  vpn_tunnel2_dpd_timeout_action = "restart"
  vpn_tunnel1_dpd_timeout_seconds = 30 # 30 second DPD timeout
  vpn_tunnel2_dpd_timeout_seconds = 30
  
  # VPN Phase 1 (IKE) Configuration
  vpn_tunnel1_phase1_dh_group_numbers = [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  vpn_tunnel2_phase1_dh_group_numbers = [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  vpn_tunnel1_phase1_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  vpn_tunnel2_phase1_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  vpn_tunnel1_phase1_integrity_algorithms = ["SHA2-256", "SHA2-384", "SHA2-512"]
  vpn_tunnel2_phase1_integrity_algorithms = ["SHA2-256", "SHA2-384", "SHA2-512"]
  
  # VPN Phase 2 (IPsec) Configuration
  vpn_tunnel1_phase2_dh_group_numbers = [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  vpn_tunnel2_phase2_dh_group_numbers = [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  vpn_tunnel1_phase2_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  vpn_tunnel2_phase2_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  vpn_tunnel1_phase2_integrity_algorithms = ["SHA2-256", "SHA2-384", "SHA2-512"]
  vpn_tunnel2_phase2_integrity_algorithms = ["SHA2-256", "SHA2-384", "SHA2-512"]
  
  # VPN Logging Configuration
  enable_vpn_connection_logging = var.enable_vpn_logging
  vpn_connection_log_retention_days = 7 # Retain logs for 7 days

  # ==============================================================================
  # Direct Connect Configuration (Optional)
  # ==============================================================================
  
  # Direct Connect Gateway
  create_direct_connect_gateway = var.enable_direct_connect
  direct_connect_gateway_name = "${var.environment}-dx-gateway"
  direct_connect_gateway_asn = 64512 # Private ASN for Direct Connect
  
  # Direct Connect Gateway Association
  create_direct_connect_gateway_association = var.enable_direct_connect
  direct_connect_allowed_prefixes = var.direct_connect_allowed_prefixes

  # ==============================================================================
  # Common Tags
  # ==============================================================================
  
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Component   = "hybrid-connectivity"
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
} 