# Outputs for AWS Hybrid Connectivity Module

# Transit Gateway Outputs
output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].id : null
}

output "transit_gateway_arn" {
  description = "The ARN of the Transit Gateway"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].arn : null
}

output "transit_gateway_owner_id" {
  description = "The ID of the AWS account that owns the Transit Gateway"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].owner_id : null
}

output "transit_gateway_association_default_route_table_id" {
  description = "The ID of the default association route table"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].association_default_route_table_id : null
}

output "transit_gateway_propagation_default_route_table_id" {
  description = "The ID of the default propagation route table"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].propagation_default_route_table_id : null
}

# Transit Gateway Route Table Outputs
output "transit_gateway_route_table_id" {
  description = "The ID of the Transit Gateway route table"
  value       = var.create_transit_gateway_route_table ? aws_ec2_transit_gateway_route_table.main[0].id : null
}

output "transit_gateway_route_table_arn" {
  description = "The ARN of the Transit Gateway route table"
  value       = var.create_transit_gateway_route_table ? aws_ec2_transit_gateway_route_table.main[0].arn : null
}

# Direct Connect Gateway Outputs
output "direct_connect_gateway_id" {
  description = "The ID of the Direct Connect Gateway"
  value       = var.create_direct_connect_gateway ? aws_dx_gateway.main[0].id : null
}

output "direct_connect_gateway_arn" {
  description = "The ARN of the Direct Connect Gateway"
  value       = var.create_direct_connect_gateway ? aws_dx_gateway.main[0].arn : null
}

output "direct_connect_gateway_owner_account_id" {
  description = "The ID of the AWS account that owns the Direct Connect Gateway"
  value       = var.create_direct_connect_gateway ? aws_dx_gateway.main[0].owner_account_id : null
}

# Direct Connect Gateway Association Outputs
output "direct_connect_gateway_association_id" {
  description = "The ID of the Direct Connect Gateway association"
  value       = var.create_direct_connect_gateway_association ? aws_dx_gateway_association.main[0].id : null
}

output "direct_connect_gateway_association_allowed_prefixes" {
  description = "The allowed prefixes for the Direct Connect Gateway association"
  value       = var.create_direct_connect_gateway_association ? aws_dx_gateway_association.main[0].allowed_prefixes : null
}

# Customer Gateway Outputs
output "customer_gateway_id" {
  description = "The ID of the Customer Gateway"
  value       = var.create_customer_gateway ? aws_customer_gateway.main[0].id : null
}

output "customer_gateway_arn" {
  description = "The ARN of the Customer Gateway"
  value       = var.create_customer_gateway ? aws_customer_gateway.main[0].arn : null
}

output "customer_gateway_bgp_asn" {
  description = "The BGP ASN of the Customer Gateway"
  value       = var.create_customer_gateway ? aws_customer_gateway.main[0].bgp_asn : null
}

output "customer_gateway_ip_address" {
  description = "The IP address of the Customer Gateway"
  value       = var.create_customer_gateway ? aws_customer_gateway.main[0].ip_address : null
}

# VPN Gateway Outputs
output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway"
  value       = var.create_vpn_gateway ? aws_vpn_gateway.main[0].id : null
}

output "vpn_gateway_arn" {
  description = "The ARN of the VPN Gateway"
  value       = var.create_vpn_gateway ? aws_vpn_gateway.main[0].arn : null
}

# VPN Connection Outputs
output "vpn_connection_id" {
  description = "The ID of the VPN Connection"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].id : null
}

output "vpn_connection_arn" {
  description = "The ARN of the VPN Connection"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].arn : null
}

output "vpn_connection_tunnel1_address" {
  description = "The public IP address of the first VPN tunnel"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].tunnel1_address : null
}

output "vpn_connection_tunnel2_address" {
  description = "The public IP address of the second VPN tunnel"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].tunnel2_address : null
}

output "vpn_connection_tunnel1_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway side)"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].tunnel1_cgw_inside_address : null
}

output "vpn_connection_tunnel2_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (Customer Gateway side)"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].tunnel2_cgw_inside_address : null
}

output "vpn_connection_tunnel1_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway side)"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].tunnel1_vgw_inside_address : null
}

output "vpn_connection_tunnel2_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (VPN Gateway side)"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].tunnel2_vgw_inside_address : null
}

output "vpn_connection_routes" {
  description = "The static routes associated with the VPN connection"
  value       = var.create_vpn_connection ? aws_vpn_connection.main[0].routes : null
}

# Transit Gateway VPC Attachment Outputs
output "transit_gateway_vpc_attachment_id" {
  description = "The ID of the Transit Gateway VPC attachment"
  value       = var.create_transit_gateway_vpc_attachment ? aws_ec2_transit_gateway_vpc_attachment.main[0].id : null
}

output "transit_gateway_vpc_attachment_arn" {
  description = "The ARN of the Transit Gateway VPC attachment"
  value       = var.create_transit_gateway_vpc_attachment ? aws_ec2_transit_gateway_vpc_attachment.main[0].arn : null
}

output "transit_gateway_vpc_attachment_subnet_ids" {
  description = "The IDs of the subnets for the Transit Gateway VPC attachment"
  value       = var.create_transit_gateway_vpc_attachment ? aws_ec2_transit_gateway_vpc_attachment.main[0].subnet_ids : null
}

# Route Table Outputs
output "transit_gateway_route_table_route_table_id" {
  description = "The ID of the VPC route table for Transit Gateway"
  value       = var.create_transit_gateway_route_table ? aws_route_table.transit_gateway[0].id : null
}

output "transit_gateway_route_table_arn" {
  description = "The ARN of the VPC route table for Transit Gateway"
  value       = var.create_transit_gateway_route_table ? aws_route_table.transit_gateway[0].arn : null
}

# CloudWatch Log Group Outputs
output "vpn_connection_log_group_arn" {
  description = "The ARN of the CloudWatch log group for VPN connection logging"
  value       = var.create_vpn_connection && var.enable_vpn_connection_logging ? aws_cloudwatch_log_group.vpn_connection[0].arn : null
}

output "vpn_connection_log_group_name" {
  description = "The name of the CloudWatch log group for VPN connection logging"
  value       = var.create_vpn_connection && var.enable_vpn_connection_logging ? aws_cloudwatch_log_group.vpn_connection[0].name : null
}

# IAM Role Outputs
output "vpn_connection_logging_role_arn" {
  description = "The ARN of the IAM role for VPN connection logging"
  value       = var.create_vpn_connection && var.enable_vpn_connection_logging ? aws_iam_role.vpn_connection_logging[0].arn : null
}

output "vpn_connection_logging_role_name" {
  description = "The name of the IAM role for VPN connection logging"
  value       = var.create_vpn_connection && var.enable_vpn_connection_logging ? aws_iam_role.vpn_connection_logging[0].name : null
}

# Summary Outputs
output "hybrid_connectivity_summary" {
  description = "Summary of the hybrid connectivity setup"
  value = {
    transit_gateway_created           = var.create_transit_gateway
    transit_gateway_id                = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].id : null
    direct_connect_gateway_created    = var.create_direct_connect_gateway
    direct_connect_gateway_id         = var.create_direct_connect_gateway ? aws_dx_gateway.main[0].id : null
    vpn_connection_created            = var.create_vpn_connection
    vpn_connection_id                 = var.create_vpn_connection ? aws_vpn_connection.main[0].id : null
    vpc_attachment_created            = var.create_transit_gateway_vpc_attachment
    vpc_attachment_id                 = var.create_transit_gateway_vpc_attachment ? aws_ec2_transit_gateway_vpc_attachment.main[0].id : null
    vpn_logging_enabled               = var.enable_vpn_connection_logging
    failover_configured               = var.create_direct_connect_gateway && var.create_vpn_connection
  }
} 