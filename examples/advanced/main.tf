# Advanced Hybrid Connectivity Example
# This example demonstrates a complete hybrid setup with Direct Connect, VPN, and failover

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

# Advanced Hybrid Connectivity Module
module "hybrid_connectivity" {
  source = "../../"

  vpc_id = var.vpc_id

  # Transit Gateway Configuration
  create_transit_gateway = true
  transit_gateway_name   = "${var.environment}-advanced-tgw"
  transit_gateway_description = "Advanced Transit Gateway for ${var.environment} environment"
  transit_gateway_asn    = var.transit_gateway_asn

  # Direct Connect Gateway (Primary Connection)
  create_direct_connect_gateway = var.enable_direct_connect
  direct_connect_gateway_name   = "${var.environment}-dx-gateway"
  direct_connect_gateway_asn    = var.direct_connect_gateway_asn

  # Direct Connect Association
  create_direct_connect_gateway_association = var.enable_direct_connect
  direct_connect_allowed_prefixes = var.direct_connect_allowed_prefixes

  # Customer Gateway (Backup Connection)
  create_customer_gateway = var.enable_vpn
  customer_gateway_name   = "${var.environment}-customer-gateway"
  customer_gateway_bgp_asn = var.customer_gateway_bgp_asn
  customer_gateway_ip_address = var.customer_gateway_ip_address

  # VPN Connection (Backup Connection)
  create_vpn_connection = var.enable_vpn
  vpn_connection_name    = "${var.environment}-vpn-connection"
  vpn_static_routes_only = var.vpn_static_routes_only
  vpn_static_routes      = var.vpn_static_routes
  vpn_tunnel1_preshared_key = var.vpn_tunnel1_preshared_key
  vpn_tunnel2_preshared_key = var.vpn_tunnel2_preshared_key

  # VPN Logging
  enable_vpn_connection_logging = var.enable_vpn_logging
  vpn_connection_log_retention_days = var.vpn_log_retention_days

  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = data.aws_subnets.private.ids

  # Route Table
  create_transit_gateway_route_table = true
  transit_gateway_route_table_subnet_ids = data.aws_subnets.private.ids

  # Custom Routes
  transit_gateway_routes = var.transit_gateway_routes

  # Common Tags
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Component   = "hybrid-connectivity"
  }
} 