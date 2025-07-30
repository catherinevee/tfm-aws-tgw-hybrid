# Outputs for Advanced Example

# Transit Gateway Outputs
output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = module.hybrid_connectivity.transit_gateway_id
}

output "transit_gateway_arn" {
  description = "The ARN of the Transit Gateway"
  value       = module.hybrid_connectivity.transit_gateway_arn
}

output "transit_gateway_owner_id" {
  description = "The ID of the AWS account that owns the Transit Gateway"
  value       = module.hybrid_connectivity.transit_gateway_owner_id
}

# Direct Connect Gateway Outputs
output "direct_connect_gateway_id" {
  description = "The ID of the Direct Connect Gateway"
  value       = module.hybrid_connectivity.direct_connect_gateway_id
}

output "direct_connect_gateway_arn" {
  description = "The ARN of the Direct Connect Gateway"
  value       = module.hybrid_connectivity.direct_connect_gateway_arn
}

output "direct_connect_gateway_association_id" {
  description = "The ID of the Direct Connect Gateway association"
  value       = module.hybrid_connectivity.direct_connect_gateway_association_id
}

# Customer Gateway Outputs
output "customer_gateway_id" {
  description = "The ID of the Customer Gateway"
  value       = module.hybrid_connectivity.customer_gateway_id
}

output "customer_gateway_ip_address" {
  description = "The IP address of the Customer Gateway"
  value       = module.hybrid_connectivity.customer_gateway_ip_address
}

# VPN Connection Outputs
output "vpn_connection_id" {
  description = "The ID of the VPN Connection"
  value       = module.hybrid_connectivity.vpn_connection_id
}

output "vpn_connection_tunnel1_address" {
  description = "The public IP address of the first VPN tunnel"
  value       = module.hybrid_connectivity.vpn_connection_tunnel1_address
}

output "vpn_connection_tunnel2_address" {
  description = "The public IP address of the second VPN tunnel"
  value       = module.hybrid_connectivity.vpn_connection_tunnel2_address
}

output "vpn_connection_tunnel1_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway side)"
  value       = module.hybrid_connectivity.vpn_connection_tunnel1_cgw_inside_address
}

output "vpn_connection_tunnel2_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (Customer Gateway side)"
  value       = module.hybrid_connectivity.vpn_connection_tunnel2_cgw_inside_address
}

output "vpn_connection_tunnel1_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway side)"
  value       = module.hybrid_connectivity.vpn_connection_tunnel1_vgw_inside_address
}

output "vpn_connection_tunnel2_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (VPN Gateway side)"
  value       = module.hybrid_connectivity.vpn_connection_tunnel2_vgw_inside_address
}

# VPC Attachment Outputs
output "transit_gateway_vpc_attachment_id" {
  description = "The ID of the Transit Gateway VPC attachment"
  value       = module.hybrid_connectivity.transit_gateway_vpc_attachment_id
}

output "transit_gateway_vpc_attachment_subnet_ids" {
  description = "The IDs of the subnets for the Transit Gateway VPC attachment"
  value       = module.hybrid_connectivity.transit_gateway_vpc_attachment_subnet_ids
}

# Route Table Outputs
output "transit_gateway_route_table_id" {
  description = "The ID of the Transit Gateway route table"
  value       = module.hybrid_connectivity.transit_gateway_route_table_id
}

# Logging Outputs
output "vpn_connection_log_group_arn" {
  description = "The ARN of the CloudWatch log group for VPN connection logging"
  value       = module.hybrid_connectivity.vpn_connection_log_group_arn
}

output "vpn_connection_logging_role_arn" {
  description = "The ARN of the IAM role for VPN connection logging"
  value       = module.hybrid_connectivity.vpn_connection_logging_role_arn
}

# Summary Output
output "hybrid_connectivity_summary" {
  description = "Summary of the hybrid connectivity setup"
  value       = module.hybrid_connectivity.hybrid_connectivity_summary
}

# Connection Information for Configuration
output "connection_configuration" {
  description = "Configuration information for on-premises setup"
  value = {
    transit_gateway_id = module.hybrid_connectivity.transit_gateway_id
    direct_connect_gateway_id = module.hybrid_connectivity.direct_connect_gateway_id
    customer_gateway_id = module.hybrid_connectivity.customer_gateway_id
    vpn_connection_id = module.hybrid_connectivity.vpn_connection_id
    vpn_tunnel1_address = module.hybrid_connectivity.vpn_connection_tunnel1_address
    vpn_tunnel2_address = module.hybrid_connectivity.vpn_connection_tunnel2_address
    vpn_tunnel1_cgw_inside_address = module.hybrid_connectivity.vpn_connection_tunnel1_cgw_inside_address
    vpn_tunnel2_cgw_inside_address = module.hybrid_connectivity.vpn_connection_tunnel2_cgw_inside_address
    vpn_tunnel1_vgw_inside_address = module.hybrid_connectivity.vpn_connection_tunnel1_vgw_inside_address
    vpn_tunnel2_vgw_inside_address = module.hybrid_connectivity.vpn_connection_tunnel2_vgw_inside_address
  }
} 