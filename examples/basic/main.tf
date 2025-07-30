# Basic Transit Gateway Example
# This example demonstrates a simple Transit Gateway setup with VPC attachment

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

# Basic Transit Gateway Module
module "hybrid_connectivity" {
  source = "../../"

  vpc_id = var.vpc_id

  # Transit Gateway Configuration
  create_transit_gateway = true
  transit_gateway_name   = "${var.environment}-tgw"
  transit_gateway_description = "Transit Gateway for ${var.environment} environment"

  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = data.aws_subnets.private.ids

  # Route Table
  create_transit_gateway_route_table = true
  transit_gateway_route_table_subnet_ids = data.aws_subnets.private.ids

  # Common Tags
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
} 