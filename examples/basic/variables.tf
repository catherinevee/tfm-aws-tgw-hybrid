# Variables for Basic Transit Gateway Example

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "hybrid-connectivity"
}

variable "vpc_id" {
  description = "VPC ID for the hybrid connectivity setup"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops-team"
}

variable "cost_center" {
  description = "Cost center for billing purposes"
  type        = string
  default     = "infrastructure"
}

# VPN Configuration Variables
variable "enable_vpn" {
  description = "Whether to enable VPN connectivity"
  type        = bool
  default     = false
}

variable "on_premises_vpn_ip" {
  description = "Public IP address of the on-premises VPN device"
  type        = string
  default     = ""
}

variable "vpn_tunnel1_preshared_key" {
  description = "Preshared key for VPN tunnel 1"
  type        = string
  default     = ""
  sensitive   = true
}

variable "vpn_tunnel2_preshared_key" {
  description = "Preshared key for VPN tunnel 2"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_vpn_logging" {
  description = "Whether to enable VPN connection logging"
  type        = bool
  default     = false
}

# Direct Connect Configuration Variables
variable "enable_direct_connect" {
  description = "Whether to enable Direct Connect connectivity"
  type        = bool
  default     = false
}

variable "direct_connect_allowed_prefixes" {
  description = "CIDR blocks allowed for Direct Connect route advertisement"
  type        = list(string)
  default     = []
} 