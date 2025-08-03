# AWS Hybrid Connectivity Module
# Supports Direct Connect, Transit Gateway, Site-to-Site VPN, and failover scenarios
# Enhanced with maximum customization options for enterprise deployments

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ==============================================================================
# Transit Gateway Configuration
# ==============================================================================

# Transit Gateway - Core networking hub for hybrid connectivity
resource "aws_ec2_transit_gateway" "main" {
  count = var.create_transit_gateway ? 1 : 0

  # Basic Configuration
  description                     = var.transit_gateway_description
  amazon_side_asn                 = var.transit_gateway_asn # Default: 64512 (Private ASN range)
  default_route_table_association = var.transit_gateway_default_route_table_association # Default: "enable"
  default_route_table_propagation = var.transit_gateway_default_route_table_propagation # Default: "enable"
  auto_accept_shared_attachments  = var.transit_gateway_auto_accept_shared_attachments # Default: "disable"
  
  # Feature Support Configuration
  dns_support                     = var.transit_gateway_dns_support # Default: "enable"
  vpn_ecmp_support                = var.transit_gateway_vpn_ecmp_support # Default: "enable"
  multicast_support               = var.transit_gateway_multicast_support # Default: "disable"

  tags = merge(
    var.common_tags,
    {
      Name = var.transit_gateway_name
      Type = "transit-gateway"
      Component = "networking"
    }
  )
}

# Transit Gateway Route Table - Controls routing between attachments
resource "aws_ec2_transit_gateway_route_table" "main" {
  count = var.create_transit_gateway_route_table ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  
  tags = merge(
    var.common_tags,
    {
      Name = var.transit_gateway_route_table_name
      Type = "transit-gateway-route-table"
      Component = "routing"
    }
  )
}

# ==============================================================================
# Direct Connect Configuration
# ==============================================================================

# Direct Connect Gateway - For dedicated network connections
resource "aws_dx_gateway" "main" {
  count = var.create_direct_connect_gateway ? 1 : 0

  name            = var.direct_connect_gateway_name
  amazon_side_asn = var.direct_connect_gateway_asn # Default: 64512 (Private ASN range)
}

# Direct Connect Gateway Association with Transit Gateway
resource "aws_dx_gateway_association" "main" {
  count = var.create_direct_connect_gateway_association ? 1 : 0

  dx_gateway_id         = aws_dx_gateway.main[0].id
  associated_gateway_id = aws_ec2_transit_gateway.main[0].id

  # Allowed prefixes for route advertisement (CIDR blocks)
  allowed_prefixes = var.direct_connect_allowed_prefixes
}

# ==============================================================================
# VPN Configuration
# ==============================================================================

# Customer Gateway - Represents on-premises VPN device
resource "aws_customer_gateway" "main" {
  count = var.create_customer_gateway ? 1 : 0

  bgp_asn    = var.customer_gateway_bgp_asn # Default: 65000 (Private ASN range)
  ip_address = var.customer_gateway_ip_address # Public IP of on-premises VPN device
  type       = "ipsec.1" # Standard IPsec VPN type

  tags = merge(
    var.common_tags,
    {
      Name = var.customer_gateway_name
      Type = "customer-gateway"
      Component = "vpn"
    }
  )
}

# VPN Gateway - AWS-side VPN termination point
resource "aws_vpn_gateway" "main" {
  count = var.create_vpn_gateway ? 1 : 0

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = var.vpn_gateway_name
      Type = "vpn-gateway"
      Component = "vpn"
    }
  )
}

# VPN Connection - IPsec tunnel between AWS and on-premises
resource "aws_vpn_connection" "main" {
  count = var.create_vpn_connection ? 1 : 0

  customer_gateway_id = aws_customer_gateway.main[0].id
  transit_gateway_id  = aws_ec2_transit_gateway.main[0].id
  type                = "ipsec.1" # Standard IPsec VPN type

  # Route Configuration
  static_routes_only = var.vpn_static_routes_only # Default: false (BGP preferred)

  # Security Configuration
  tunnel1_preshared_key = var.vpn_tunnel1_preshared_key # Must be 8-64 characters
  tunnel2_preshared_key = var.vpn_tunnel2_preshared_key # Must be 8-64 characters

  # Dead Peer Detection (DPD) Configuration
  tunnel1_dpd_timeout_action = var.vpn_tunnel1_dpd_timeout_action # Options: "clear", "restart", "hold"
  tunnel2_dpd_timeout_action = var.vpn_tunnel2_dpd_timeout_action # Options: "clear", "restart", "hold"
  tunnel1_dpd_timeout_seconds = var.vpn_tunnel1_dpd_timeout_seconds # Range: 30-3600 seconds
  tunnel2_dpd_timeout_seconds = var.vpn_tunnel2_dpd_timeout_seconds # Range: 30-3600 seconds

  # Phase 1 (IKE) Configuration - Diffie-Hellman Groups
  tunnel1_phase1_dh_group_numbers   = var.vpn_tunnel1_phase1_dh_group_numbers # Configurable DH groups
  tunnel2_phase1_dh_group_numbers   = var.vpn_tunnel2_phase1_dh_group_numbers # Configurable DH groups
  
  # Phase 2 (IPsec) Configuration - Diffie-Hellman Groups
  tunnel1_phase2_dh_group_numbers   = var.vpn_tunnel1_phase2_dh_group_numbers # Configurable DH groups
  tunnel2_phase2_dh_group_numbers   = var.vpn_tunnel2_phase2_dh_group_numbers # Configurable DH groups
  
  # Phase 1 (IKE) Configuration - Encryption Algorithms
  tunnel1_phase1_encryption_algorithms = var.vpn_tunnel1_phase1_encryption_algorithms # Configurable encryption
  tunnel2_phase1_encryption_algorithms = var.vpn_tunnel2_phase1_encryption_algorithms # Configurable encryption
  
  # Phase 2 (IPsec) Configuration - Encryption Algorithms
  tunnel1_phase2_encryption_algorithms = var.vpn_tunnel1_phase2_encryption_algorithms # Configurable encryption
  tunnel2_phase2_encryption_algorithms = var.vpn_tunnel2_phase2_encryption_algorithms # Configurable encryption
  
  # Phase 1 (IKE) Configuration - Integrity Algorithms
  tunnel1_phase1_integrity_algorithms  = var.vpn_tunnel1_phase1_integrity_algorithms # Configurable integrity
  tunnel2_phase1_integrity_algorithms  = var.vpn_tunnel2_phase1_integrity_algorithms # Configurable integrity
  
  # Phase 2 (IPsec) Configuration - Integrity Algorithms
  tunnel1_phase2_integrity_algorithms  = var.vpn_tunnel1_phase2_integrity_algorithms # Configurable integrity
  tunnel2_phase2_integrity_algorithms  = var.vpn_tunnel2_phase2_integrity_algorithms # Configurable integrity

  tags = merge(
    var.common_tags,
    {
      Name = var.vpn_connection_name
      Type = "vpn-connection"
      Component = "vpn"
    }
  )
}

# VPN Connection Route - Static routes for VPN (if not using BGP)
resource "aws_vpn_connection_route" "main" {
  count = var.create_vpn_connection && var.vpn_static_routes_only ? length(var.vpn_static_routes) : 0

  destination_cidr_block = var.vpn_static_routes[count.index] # CIDR blocks for on-premises networks
  vpn_connection_id      = aws_vpn_connection.main[0].id
}

# ==============================================================================
# Transit Gateway VPC Attachment Configuration
# ==============================================================================

# Transit Gateway VPC Attachment - Connects VPC to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.create_transit_gateway_vpc_attachment ? 1 : 0

  subnet_ids         = var.transit_gateway_subnet_ids # Must be in different AZs
  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  vpc_id             = var.vpc_id

  # Feature Support Configuration
  appliance_mode_support = var.transit_gateway_appliance_mode_support # Default: "disable"
  dns_support            = var.transit_gateway_dns_support # Default: "enable"
  ipv6_support           = var.transit_gateway_ipv6_support # Default: "disable"

  tags = merge(
    var.common_tags,
    {
      Name = var.transit_gateway_vpc_attachment_name
      Type = "transit-gateway-vpc-attachment"
      Component = "connectivity"
    }
  )
}

# Transit Gateway Route Table Association - Associates VPC attachment with route table
resource "aws_ec2_transit_gateway_route_table_association" "main" {
  count = var.create_transit_gateway_route_table_association ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main[0].id
}

# Transit Gateway Route Table Propagation - Propagates routes from VPC attachment
resource "aws_ec2_transit_gateway_route_table_propagation" "main" {
  count = var.create_transit_gateway_route_table_propagation ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main[0].id
}

# ==============================================================================
# VPC Route Table Configuration
# ==============================================================================

# Route Table for VPC to Transit Gateway - Routes traffic from VPC to Transit Gateway
resource "aws_route_table" "transit_gateway" {
  count = var.create_transit_gateway_route_table ? 1 : 0

  vpc_id = var.vpc_id

  # Dynamic route configuration for Transit Gateway
  dynamic "route" {
    for_each = var.transit_gateway_routes
    content {
      cidr_block         = route.value.cidr_block # Destination CIDR blocks
      transit_gateway_id = aws_ec2_transit_gateway.main[0].id
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.transit_gateway_route_table_name
      Type = "route-table"
      Component = "routing"
    }
  )
}

# Route Table Association - Associates subnets with Transit Gateway route table
resource "aws_route_table_association" "transit_gateway" {
  count = var.create_transit_gateway_route_table ? length(var.transit_gateway_route_table_subnet_ids) : 0

  subnet_id      = var.transit_gateway_route_table_subnet_ids[count.index] # Subnets to route through Transit Gateway
  route_table_id = aws_route_table.transit_gateway[0].id
}

# ==============================================================================
# Monitoring and Logging Configuration
# ==============================================================================

# CloudWatch Log Group for VPN Connection Monitoring
resource "aws_cloudwatch_log_group" "vpn_connection" {
  count = var.create_vpn_connection && var.enable_vpn_connection_logging ? 1 : 0

  name              = "/aws/vpn-connection/${var.vpn_connection_name}" # Log group naming convention
  retention_in_days = var.vpn_connection_log_retention_days # Default: 7 days

  tags = merge(
    var.common_tags,
    {
      Name = "${var.vpn_connection_name}-logs"
      Type = "cloudwatch-log-group"
      Component = "monitoring"
    }
  )
}

# IAM Role for VPN Connection Logging - Allows VPN service to write logs
resource "aws_iam_role" "vpn_connection_logging" {
  count = var.create_vpn_connection && var.enable_vpn_connection_logging ? 1 : 0

  name = "${var.vpn_connection_name}-vpn-logging-role"

  # Trust policy for VPN service
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpn.amazonaws.com" # VPN service principal
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${var.vpn_connection_name}-vpn-logging-role"
      Type = "iam-role"
      Component = "security"
    }
  )
}

# IAM Policy for VPN Connection Logging - Permissions for CloudWatch Logs
resource "aws_iam_role_policy" "vpn_connection_logging" {
  count = var.create_vpn_connection && var.enable_vpn_connection_logging ? 1 : 0

  name = "${var.vpn_connection_name}-vpn-logging-policy"
  role = aws_iam_role.vpn_connection_logging[0].id

  # Policy for CloudWatch Logs access
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.vpn_connection[0].arn}:*"
      }
    ]
  })
}

# VPN Connection Logging Configuration - Enables logging for VPN connection
resource "aws_vpn_connection_logging" "main" {
  count = var.create_vpn_connection && var.enable_vpn_connection_logging ? 1 : 0

  vpn_connection_id = aws_vpn_connection.main[0].id
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.vpn_connection[0].arn
  iam_role_arn = aws_iam_role.vpn_connection_logging[0].arn
} 