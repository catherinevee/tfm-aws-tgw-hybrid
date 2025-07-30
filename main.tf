# AWS Hybrid Connectivity Module
# Supports Direct Connect, Transit Gateway, Site-to-Site VPN, and failover scenarios

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  count = var.create_transit_gateway ? 1 : 0

  description                     = var.transit_gateway_description
  amazon_side_asn                 = var.transit_gateway_asn
  default_route_table_association = var.transit_gateway_default_route_table_association
  default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  auto_accept_shared_attachments  = var.transit_gateway_auto_accept_shared_attachments
  dns_support                     = var.transit_gateway_dns_support
  vpn_ecmp_support                = var.transit_gateway_vpn_ecmp_support
  multicast_support               = var.transit_gateway_multicast_support

  tags = merge(
    var.common_tags,
    {
      Name = var.transit_gateway_name
    }
  )
}

# Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "main" {
  count = var.create_transit_gateway_route_table ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  tags = merge(
    var.common_tags,
    {
      Name = var.transit_gateway_route_table_name
    }
  )
}

# Direct Connect Gateway
resource "aws_dx_gateway" "main" {
  count = var.create_direct_connect_gateway ? 1 : 0

  name            = var.direct_connect_gateway_name
  amazon_side_asn = var.direct_connect_gateway_asn

  tags = merge(
    var.common_tags,
    {
      Name = var.direct_connect_gateway_name
    }
  )
}

# Direct Connect Gateway Association with Transit Gateway
resource "aws_dx_gateway_association" "main" {
  count = var.create_direct_connect_gateway_association ? 1 : 0

  dx_gateway_id         = aws_dx_gateway.main[0].id
  associated_gateway_id = aws_ec2_transit_gateway.main[0].id

  allowed_prefixes = var.direct_connect_allowed_prefixes

  tags = merge(
    var.common_tags,
    {
      Name = "${var.direct_connect_gateway_name}-tgw-association"
    }
  )
}

# Customer Gateway for Site-to-Site VPN
resource "aws_customer_gateway" "main" {
  count = var.create_customer_gateway ? 1 : 0

  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip_address
  type       = "ipsec.1"

  tags = merge(
    var.common_tags,
    {
      Name = var.customer_gateway_name
    }
  )
}

# VPN Gateway
resource "aws_vpn_gateway" "main" {
  count = var.create_vpn_gateway ? 1 : 0

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = var.vpn_gateway_name
    }
  )
}

# VPN Connection
resource "aws_vpn_connection" "main" {
  count = var.create_vpn_connection ? 1 : 0

  customer_gateway_id = aws_customer_gateway.main[0].id
  transit_gateway_id  = aws_ec2_transit_gateway.main[0].id
  type                = "ipsec.1"

  static_routes_only = var.vpn_static_routes_only

  tags = merge(
    var.common_tags,
    {
      Name = var.vpn_connection_name
    }
  )

  tunnel1_inside_ip_version = "ipv4"
  tunnel2_inside_ip_version = "ipv4"

  tunnel1_preshared_key = var.vpn_tunnel1_preshared_key
  tunnel2_preshared_key = var.vpn_tunnel2_preshared_key

  tunnel1_dpd_timeout_action = "restart"
  tunnel2_dpd_timeout_action = "restart"

  tunnel1_dpd_timeout_seconds = 30
  tunnel2_dpd_timeout_seconds = 30

  tunnel1_phase1_dh_group_numbers   = [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  tunnel1_phase2_dh_group_numbers   = [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  tunnel1_phase1_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  tunnel1_phase2_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]

  tunnel2_phase1_dh_group_numbers   = [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  tunnel2_phase2_dh_group_numbers   = [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  tunnel2_phase1_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  tunnel2_phase2_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
}

# VPN Connection Route (if using static routes)
resource "aws_vpn_connection_route" "main" {
  count = var.create_vpn_connection && var.vpn_static_routes_only ? length(var.vpn_static_routes) : 0

  destination_cidr_block = var.vpn_static_routes[count.index]
  vpn_connection_id      = aws_vpn_connection.main[0].id
}

# Transit Gateway VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.create_transit_gateway_vpc_attachment ? 1 : 0

  subnet_ids         = var.transit_gateway_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  vpc_id             = var.vpc_id

  appliance_mode_support = var.transit_gateway_appliance_mode_support
  dns_support            = var.transit_gateway_dns_support
  ipv6_support           = var.transit_gateway_ipv6_support

  tags = merge(
    var.common_tags,
    {
      Name = var.transit_gateway_vpc_attachment_name
    }
  )
}

# Transit Gateway Route Table Association
resource "aws_ec2_transit_gateway_route_table_association" "main" {
  count = var.create_transit_gateway_route_table_association ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main[0].id
}

# Transit Gateway Route Table Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "main" {
  count = var.create_transit_gateway_route_table_propagation ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main[0].id
}

# Route Table for VPC to Transit Gateway
resource "aws_route_table" "transit_gateway" {
  count = var.create_transit_gateway_route_table ? 1 : 0

  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.transit_gateway_routes
    content {
      cidr_block         = route.value.cidr_block
      transit_gateway_id = aws_ec2_transit_gateway.main[0].id
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.transit_gateway_route_table_name
    }
  )
}

# Route Table Association
resource "aws_route_table_association" "transit_gateway" {
  count = var.create_transit_gateway_route_table ? length(var.transit_gateway_route_table_subnet_ids) : 0

  subnet_id      = var.transit_gateway_route_table_subnet_ids[count.index]
  route_table_id = aws_route_table.transit_gateway[0].id
}

# CloudWatch Log Group for VPN Connection Monitoring
resource "aws_cloudwatch_log_group" "vpn_connection" {
  count = var.create_vpn_connection && var.enable_vpn_connection_logging ? 1 : 0

  name              = "/aws/vpn-connection/${var.vpn_connection_name}"
  retention_in_days = var.vpn_connection_log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name = "${var.vpn_connection_name}-logs"
    }
  )
}

# IAM Role for VPN Connection Logging
resource "aws_iam_role" "vpn_connection_logging" {
  count = var.create_vpn_connection && var.enable_vpn_connection_logging ? 1 : 0

  name = "${var.vpn_connection_name}-vpn-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpn.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${var.vpn_connection_name}-vpn-logging-role"
    }
  )
}

# IAM Policy for VPN Connection Logging
resource "aws_iam_role_policy" "vpn_connection_logging" {
  count = var.create_vpn_connection && var.enable_vpn_connection_logging ? 1 : 0

  name = "${var.vpn_connection_name}-vpn-logging-policy"
  role = aws_iam_role.vpn_connection_logging[0].id

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

# VPN Connection Logging Configuration
resource "aws_vpn_connection_logging" "main" {
  count = var.create_vpn_connection && var.enable_vpn_connection_logging ? 1 : 0

  vpn_connection_id = aws_vpn_connection.main[0].id
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.vpn_connection[0].arn
  iam_role_arn = aws_iam_role.vpn_connection_logging[0].arn
} 