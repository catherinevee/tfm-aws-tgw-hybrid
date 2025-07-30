# Outputs for Test Configuration

output "test_vpc_id" {
  description = "The ID of the test VPC"
  value       = aws_vpc.test.id
}

output "test_subnet_ids" {
  description = "The IDs of the test subnets"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = module.hybrid_connectivity_test.transit_gateway_id
}

output "transit_gateway_vpc_attachment_id" {
  description = "The ID of the Transit Gateway VPC attachment"
  value       = module.hybrid_connectivity_test.transit_gateway_vpc_attachment_id
}

output "hybrid_connectivity_summary" {
  description = "Summary of the test hybrid connectivity setup"
  value       = module.hybrid_connectivity_test.hybrid_connectivity_summary
}

output "test_results" {
  description = "Test results summary"
  value = {
    vpc_created = aws_vpc.test.id != null
    subnets_created = length([aws_subnet.private_1.id, aws_subnet.private_2.id]) == 2
    transit_gateway_created = module.hybrid_connectivity_test.transit_gateway_id != null
    vpc_attachment_created = module.hybrid_connectivity_test.transit_gateway_vpc_attachment_id != null
    vpn_tested = var.test_vpn
  }
} 