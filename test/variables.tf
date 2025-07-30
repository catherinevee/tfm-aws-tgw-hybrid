# Variables for Test Configuration

variable "aws_region" {
  description = "AWS region for testing"
  type        = string
  default     = "us-west-2"
}

variable "test_vpn" {
  description = "Whether to test VPN functionality"
  type        = bool
  default     = false
}

variable "test_customer_gateway_ip" {
  description = "Test customer gateway IP address"
  type        = string
  default     = "203.0.113.1"
}

variable "test_vpn_tunnel1_key" {
  description = "Test VPN tunnel 1 preshared key"
  type        = string
  default     = "test-key-1"
  sensitive   = true
}

variable "test_vpn_tunnel2_key" {
  description = "Test VPN tunnel 2 preshared key"
  type        = string
  default     = "test-key-2"
  sensitive   = true
} 