# Outputs for Basic Example

output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = module.hybrid_connectivity.transit_gateway_id
}

output "transit_gateway_arn" {
  description = "The ARN of the Transit Gateway"
  value       = module.hybrid_connectivity.transit_gateway_arn
}

output "transit_gateway_vpc_attachment_id" {
  description = "The ID of the Transit Gateway VPC attachment"
  value       = module.hybrid_connectivity.transit_gateway_vpc_attachment_id
}

output "transit_gateway_route_table_id" {
  description = "The ID of the Transit Gateway route table"
  value       = module.hybrid_connectivity.transit_gateway_route_table_id
}

output "hybrid_connectivity_summary" {
  description = "Summary of the hybrid connectivity setup"
  value       = module.hybrid_connectivity.hybrid_connectivity_summary
} 