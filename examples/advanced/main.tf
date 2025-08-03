# Advanced Transit Gateway Example
# This example demonstrates complex enterprise hybrid connectivity with multiple components
# Enhanced with comprehensive customization options for enterprise deployments

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

# Data sources for existing infrastructure
data "aws_vpc" "main" {
  id = var.vpc_id
}

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

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  
  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}

# Advanced Hybrid Connectivity Module
module "hybrid_connectivity" {
  source = "../../"

  # Required Configuration
  vpc_id = var.vpc_id

  # ==============================================================================
  # Transit Gateway Configuration - Enterprise Settings
  # ==============================================================================
  
  # Primary Transit Gateway
  create_transit_gateway = true
  transit_gateway_name   = "${var.environment}-primary-tgw"
  transit_gateway_description = "Primary Transit Gateway for ${var.environment} environment with enterprise features"
  
  # Advanced Transit Gateway Settings for Enterprise
  transit_gateway_asn = 64512 # Private ASN for primary TGW
  transit_gateway_default_route_table_association = "enable" # Auto-associate for simplicity
  transit_gateway_default_route_table_propagation = "enable" # Auto-propagate for simplicity
  transit_gateway_auto_accept_shared_attachments = "disable" # Manual approval for security
  transit_gateway_dns_support = "enable" # Enable DNS resolution
  transit_gateway_vpn_ecmp_support = "enable" # Enable VPN load balancing
  transit_gateway_multicast_support = var.enable_multicast # Conditional multicast support

  # ==============================================================================
  # VPC Attachment Configuration - Multi-AZ Setup
  # ==============================================================================
  
  # VPC Attachment with High Availability
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = data.aws_subnets.private.ids # Multi-AZ subnets
  transit_gateway_vpc_attachment_name = "${var.environment}-primary-tgw-vpc-attachment"
  
  # Advanced VPC Attachment Settings
  transit_gateway_appliance_mode_support = var.enable_appliance_mode # Enable for load balancers
  transit_gateway_ipv6_support = var.enable_ipv6 # Conditional IPv6 support

  # ==============================================================================
  # Route Table Configuration - Complex Routing
  # ==============================================================================
  
  # Custom Route Table
  create_transit_gateway_route_table = true
  transit_gateway_route_table_name = "${var.environment}-primary-tgw-route-table"
  transit_gateway_route_table_subnet_ids = data.aws_subnets.private.ids
  
  # Route Table Management
  create_transit_gateway_route_table_association = true
  create_transit_gateway_route_table_propagation = true
  
  # Complex Route Configuration
  transit_gateway_routes = var.transit_gateway_routes

  # ==============================================================================
  # VPN Configuration - Multi-Site VPN
  # ==============================================================================
  
  # Primary Customer Gateway (Main Data Center)
  create_customer_gateway = var.enable_vpn
  customer_gateway_name = "${var.environment}-primary-customer-gateway"
  customer_gateway_bgp_asn = 65000 # Primary ASN
  customer_gateway_ip_address = var.primary_vpn_ip
  
  # Primary VPN Gateway
  create_vpn_gateway = var.enable_vpn
  vpn_gateway_name = "${var.environment}-primary-vpn-gateway"
  
  # Primary VPN Connection
  create_vpn_connection = var.enable_vpn
  vpn_connection_name = "${var.environment}-primary-vpn-connection"
  vpn_static_routes_only = false # Use BGP for dynamic routing
  
  # Enhanced VPN Security Configuration
  vpn_tunnel1_preshared_key = var.primary_vpn_tunnel1_preshared_key
  vpn_tunnel2_preshared_key = var.primary_vpn_tunnel2_preshared_key
  
  # Advanced VPN Tunnel Configuration
  vpn_tunnel1_dpd_timeout_action = "restart" # Restart on DPD timeout
  vpn_tunnel2_dpd_timeout_action = "restart"
  vpn_tunnel1_dpd_timeout_seconds = 30 # 30 second DPD timeout
  vpn_tunnel2_dpd_timeout_seconds = 30
  
  # High-Security VPN Phase 1 (IKE) Configuration
  vpn_tunnel1_phase1_dh_group_numbers = [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24] # Strong DH groups
  vpn_tunnel2_phase1_dh_group_numbers = [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  vpn_tunnel1_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"] # Strong encryption only
  vpn_tunnel2_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  vpn_tunnel1_phase1_integrity_algorithms = ["SHA2-256", "SHA2-384", "SHA2-512"] # Strong integrity
  vpn_tunnel2_phase1_integrity_algorithms = ["SHA2-256", "SHA2-384", "SHA2-512"]
  
  # High-Security VPN Phase 2 (IPsec) Configuration
  vpn_tunnel1_phase2_dh_group_numbers = [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24] # Strong DH groups
  vpn_tunnel2_phase2_dh_group_numbers = [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  vpn_tunnel1_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"] # Strong encryption only
  vpn_tunnel2_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  vpn_tunnel1_phase2_integrity_algorithms = ["SHA2-256", "SHA2-384", "SHA2-512"] # Strong integrity
  vpn_tunnel2_phase2_integrity_algorithms = ["SHA2-256", "SHA2-384", "SHA2-512"]
  
  # Enhanced VPN Logging Configuration
  enable_vpn_connection_logging = var.enable_vpn_logging
  vpn_connection_log_retention_days = var.vpn_log_retention_days

  # ==============================================================================
  # Direct Connect Configuration - Enterprise Connectivity
  # ==============================================================================
  
  # Direct Connect Gateway for Enterprise Connectivity
  create_direct_connect_gateway = var.enable_direct_connect
  direct_connect_gateway_name = "${var.environment}-dx-gateway"
  direct_connect_gateway_asn = 64512 # Private ASN for Direct Connect
  
  # Direct Connect Gateway Association
  create_direct_connect_gateway_association = var.enable_direct_connect
  direct_connect_allowed_prefixes = var.direct_connect_allowed_prefixes

  # ==============================================================================
  # Enhanced Monitoring and Security Configuration
  # ==============================================================================
  
  # Advanced Hybrid Configuration
  hybrid_config = {
    enable_transit_gateway = true
    enable_direct_connect = var.enable_direct_connect
    enable_vpn_connectivity = var.enable_vpn
    enable_customer_gateway = var.enable_vpn
    enable_vpn_gateway = var.enable_vpn
    enable_vpc_attachment = true
    enable_route_tables = true
    enable_route_propagation = true
    enable_route_association = true
    enable_multicast = var.enable_multicast
    enable_dns_support = true
    enable_vpn_ecmp = true
    enable_auto_accept = false
    enable_logging = var.enable_vpn_logging
    enable_monitoring = true
    enable_metrics = true
    enable_alerts = true
    enable_dashboard = true
    enable_audit = true
    enable_backup = var.enable_backup
    enable_disaster_recovery = var.enable_disaster_recovery
  }

  # Enhanced Monitoring Configuration
  hybrid_monitoring_config = {
    enable_cloudwatch_monitoring = true
    enable_cloudwatch_logs = true
    enable_cloudwatch_metrics = true
    enable_cloudwatch_alarms = true
    enable_cloudwatch_dashboard = true
    enable_cloudwatch_insights = var.enable_cloudwatch_insights
    enable_cloudwatch_anomaly_detection = var.enable_anomaly_detection
    enable_cloudwatch_log_retention = true
    enable_cloudwatch_log_encryption = true
    enable_cloudwatch_log_performance_logging = true
    enable_cloudwatch_log_operational_logging = true
    enable_cloudwatch_log_error_logging = true
    enable_cloudwatch_log_warning_logging = true
    enable_cloudwatch_log_info_logging = true
  }

  # Enhanced Security Configuration
  hybrid_security_config = {
    enable_encryption = true
    enable_access_control = true
    enable_audit_logging = true
    enable_compliance = var.enable_compliance
    enable_governance = var.enable_governance
    enable_privacy = var.enable_privacy
    enable_fairness = false
    enable_bias_detection = false
    enable_explainability = false
    enable_interpretability = false
    enable_robustness = true
    enable_adversarial_protection = false
    enable_poisoning_protection = false
    enable_extraction_protection = false
    enable_inversion_protection = false
    enable_membership_inference_protection = false
    enable_model_inversion_protection = false
    enable_attribute_inference_protection = false
    enable_property_inference_protection = false
    enable_reconstruction_protection = false
    enable_stealing_protection = false
    enable_evasion_protection = false
    enable_backdoor_protection = false
    enable_trojan_protection = false
    enable_trigger_protection = false
  }

  # ==============================================================================
  # Enterprise Tags and Metadata
  # ==============================================================================
  
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Component   = "hybrid-connectivity"
    Owner       = var.owner
    CostCenter  = var.cost_center
    DataClassification = var.data_classification
    Compliance  = var.compliance_requirements
    Backup      = var.enable_backup ? "enabled" : "disabled"
    DR          = var.enable_disaster_recovery ? "enabled" : "disabled"
    Security    = "high"
    NetworkTier = "enterprise"
  }
} 