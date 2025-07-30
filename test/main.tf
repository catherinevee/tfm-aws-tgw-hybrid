# Test Configuration for AWS Hybrid Connectivity Module

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

# Create a test VPC
resource "aws_vpc" "test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "test-vpc"
    Environment = "test"
    Project     = "hybrid-connectivity-test"
  }
}

# Create test subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = "test-private-subnet-1"
    Type        = "private"
    Environment = "test"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = "test-private-subnet-2"
    Type        = "private"
    Environment = "test"
  }
}

# Test the hybrid connectivity module
module "hybrid_connectivity_test" {
  source = "../"

  vpc_id = aws_vpc.test.id

  # Transit Gateway Configuration
  create_transit_gateway = true
  transit_gateway_name   = "test-tgw"
  transit_gateway_description = "Test Transit Gateway"

  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  # Route Table
  create_transit_gateway_route_table = true
  transit_gateway_route_table_subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  # Test VPN Configuration (optional)
  create_customer_gateway = var.test_vpn
  customer_gateway_name   = "test-customer-gateway"
  customer_gateway_bgp_asn = 65000
  customer_gateway_ip_address = var.test_customer_gateway_ip

  create_vpn_connection = var.test_vpn
  vpn_connection_name    = "test-vpn-connection"
  vpn_static_routes_only = false
  vpn_tunnel1_preshared_key = var.test_vpn_tunnel1_key
  vpn_tunnel2_preshared_key = var.test_vpn_tunnel2_key

  # VPN Logging
  enable_vpn_connection_logging = var.test_vpn
  vpn_connection_log_retention_days = 7

  # Common Tags
  common_tags = {
    Environment = "test"
    Project     = "hybrid-connectivity-test"
    ManagedBy   = "terraform"
  }
} 