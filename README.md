# AWS Transit Gateway Hybrid Connectivity Module

A comprehensive Terraform module for deploying enterprise-grade hybrid connectivity solutions using AWS Transit Gateway, Direct Connect, and Site-to-Site VPN connections.

## 🚀 Features

### Core Connectivity
- **Transit Gateway**: Centralized network hub for VPC and on-premises connectivity
- **Direct Connect**: Dedicated network connections for high-bandwidth, low-latency requirements
- **Site-to-Site VPN**: Secure IPsec tunnels for remote connectivity
- **VPC Attachments**: Seamless VPC integration with Transit Gateway

### Advanced Configuration
- **Multi-Tunnel VPN**: Configurable Phase 1 (IKE) and Phase 2 (IPsec) settings
- **BGP Support**: Dynamic routing with customizable ASN configurations
- **Route Management**: Flexible route table associations and propagations
- **High Availability**: Multi-AZ deployments with failover capabilities

### Security & Compliance
- **Encryption**: Configurable encryption algorithms (AES128, AES256, GCM)
- **Integrity**: SHA2-256, SHA2-384, SHA2-512 integrity algorithms
- **Dead Peer Detection**: Configurable DPD timeout and actions
- **Access Control**: IAM roles and policies for secure access

### Monitoring & Logging
- **CloudWatch Integration**: Comprehensive logging and monitoring
- **VPN Connection Logging**: Detailed VPN tunnel monitoring
- **Metrics & Alarms**: Performance monitoring and alerting
- **Audit Trail**: Complete audit logging for compliance

## 📋 Prerequisites

- Terraform >= 1.0
- AWS Provider >= 5.0
- Existing VPC with appropriate subnets
- AWS credentials configured

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   On-Premises   │    │   Direct Connect │    │   AWS Transit   │
│   Data Center   │◄──►│   Connection     │◄──►│   Gateway       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                                              │
         │                                              │
         │              ┌─────────────────┐             │
         └──────────────►│   Site-to-Site  │◄────────────┘
                        │   VPN Tunnel    │
                        └─────────────────┘
```

## 🔧 Usage

### Basic Example

```hcl
module "hybrid_connectivity" {
  source = "path/to/tfm-aws-tgw-hybrid"

  # Required Configuration
  vpc_id = "vpc-12345678"

  # Transit Gateway Configuration
  create_transit_gateway = true
  transit_gateway_name   = "my-transit-gateway"
  transit_gateway_asn    = 64512

  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # Common Tags
  common_tags = {
    Environment = "production"
    Project     = "hybrid-connectivity"
    ManagedBy   = "terraform"
  }
}
```

### Advanced Example with VPN

```hcl
module "hybrid_connectivity" {
  source = "path/to/tfm-aws-tgw-hybrid"

  # Required Configuration
  vpc_id = "vpc-12345678"

  # Transit Gateway Configuration
  create_transit_gateway = true
  transit_gateway_name   = "enterprise-tgw"
  transit_gateway_asn    = 64512

  # VPN Configuration
  create_customer_gateway = true
  customer_gateway_name   = "on-premises-gateway"
  customer_gateway_bgp_asn = 65000
  customer_gateway_ip_address = "203.0.113.1"

  create_vpn_connection = true
  vpn_connection_name   = "enterprise-vpn"
  vpn_tunnel1_preshared_key = "your-secure-key-1"
  vpn_tunnel2_preshared_key = "your-secure-key-2"

  # Advanced VPN Settings
  vpn_tunnel1_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  vpn_tunnel1_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  vpn_tunnel1_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  vpn_tunnel1_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]

  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # Logging
  enable_vpn_connection_logging = true
  vpn_connection_log_retention_days = 30

  common_tags = {
    Environment = "production"
    Project     = "enterprise-connectivity"
    Security    = "high"
  }
}
```

## 📖 Input Variables

### Required Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `vpc_id` | VPC ID for the hybrid connectivity setup | `string` | - |

### Transit Gateway Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `create_transit_gateway` | Whether to create a Transit Gateway | `bool` | `true` |
| `transit_gateway_name` | Name of the Transit Gateway | `string` | `"main-transit-gateway"` |
| `transit_gateway_description` | Description of the Transit Gateway | `string` | `"Main Transit Gateway for hybrid connectivity"` |
| `transit_gateway_asn` | Private ASN for the Transit Gateway (64512-65534) | `number` | `64512` |
| `transit_gateway_default_route_table_association` | Auto-associate attachments with default route table | `string` | `"enable"` |
| `transit_gateway_default_route_table_propagation` | Auto-propagate routes to default route table | `string` | `"enable"` |
| `transit_gateway_auto_accept_shared_attachments` | Auto-accept shared attachments | `string` | `"disable"` |
| `transit_gateway_dns_support` | Enable DNS support | `string` | `"enable"` |
| `transit_gateway_vpn_ecmp_support` | Enable VPN ECMP support | `string` | `"enable"` |
| `transit_gateway_multicast_support` | Enable multicast support | `string` | `"disable"` |

### VPN Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `create_customer_gateway` | Whether to create a Customer Gateway | `bool` | `false` |
| `customer_gateway_name` | Name of the Customer Gateway | `string` | `"main-customer-gateway"` |
| `customer_gateway_bgp_asn` | BGP ASN for the Customer Gateway | `number` | `65000` |
| `customer_gateway_ip_address` | IP address of the on-premises VPN device | `string` | `""` |
| `create_vpn_connection` | Whether to create a VPN Connection | `bool` | `false` |
| `vpn_connection_name` | Name of the VPN Connection | `string` | `"main-vpn-connection"` |
| `vpn_static_routes_only` | Use static routes only (false = BGP preferred) | `bool` | `false` |
| `vpn_static_routes` | List of CIDR blocks for static routes | `list(string)` | `[]` |
| `vpn_tunnel1_preshared_key` | Preshared key for tunnel 1 (8-64 chars) | `string` | `""` |
| `vpn_tunnel2_preshared_key` | Preshared key for tunnel 2 (8-64 chars) | `string` | `""` |

### VPN Tunnel Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `vpn_tunnel1_dpd_timeout_action` | DPD timeout action for tunnel 1 | `string` | `"restart"` |
| `vpn_tunnel2_dpd_timeout_action` | DPD timeout action for tunnel 2 | `string` | `"restart"` |
| `vpn_tunnel1_dpd_timeout_seconds` | DPD timeout in seconds for tunnel 1 (30-3600) | `number` | `30` |
| `vpn_tunnel2_dpd_timeout_seconds` | DPD timeout in seconds for tunnel 2 (30-3600) | `number` | `30` |

### VPN Phase 1 (IKE) Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `vpn_tunnel1_phase1_dh_group_numbers` | Phase 1 DH group numbers for tunnel 1 | `list(number)` | `[2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]` |
| `vpn_tunnel2_phase1_dh_group_numbers` | Phase 1 DH group numbers for tunnel 2 | `list(number)` | `[2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]` |
| `vpn_tunnel1_phase1_encryption_algorithms` | Phase 1 encryption algorithms for tunnel 1 | `list(string)` | `["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]` |
| `vpn_tunnel2_phase1_encryption_algorithms` | Phase 1 encryption algorithms for tunnel 2 | `list(string)` | `["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]` |
| `vpn_tunnel1_phase1_integrity_algorithms` | Phase 1 integrity algorithms for tunnel 1 | `list(string)` | `["SHA2-256", "SHA2-384", "SHA2-512"]` |
| `vpn_tunnel2_phase1_integrity_algorithms` | Phase 1 integrity algorithms for tunnel 2 | `list(string)` | `["SHA2-256", "SHA2-384", "SHA2-512"]` |

### VPN Phase 2 (IPsec) Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `vpn_tunnel1_phase2_dh_group_numbers` | Phase 2 DH group numbers for tunnel 1 | `list(number)` | `[2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]` |
| `vpn_tunnel2_phase2_dh_group_numbers` | Phase 2 DH group numbers for tunnel 2 | `list(number)` | `[2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]` |
| `vpn_tunnel1_phase2_encryption_algorithms` | Phase 2 encryption algorithms for tunnel 1 | `list(string)` | `["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]` |
| `vpn_tunnel2_phase2_encryption_algorithms` | Phase 2 encryption algorithms for tunnel 2 | `list(string)` | `["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]` |
| `vpn_tunnel1_phase2_integrity_algorithms` | Phase 2 integrity algorithms for tunnel 1 | `list(string)` | `["SHA2-256", "SHA2-384", "SHA2-512"]` |
| `vpn_tunnel2_phase2_integrity_algorithms` | Phase 2 integrity algorithms for tunnel 2 | `list(string)` | `["SHA2-256", "SHA2-384", "SHA2-512"]` |

### Direct Connect Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `create_direct_connect_gateway` | Whether to create a Direct Connect Gateway | `bool` | `false` |
| `direct_connect_gateway_name` | Name of the Direct Connect Gateway | `string` | `"main-dx-gateway"` |
| `direct_connect_gateway_asn` | ASN for the Direct Connect Gateway | `number` | `64512` |
| `create_direct_connect_gateway_association` | Whether to create Direct Connect Gateway association | `bool` | `false` |
| `direct_connect_allowed_prefixes` | CIDR blocks for Direct Connect route advertisement | `list(string)` | `[]` |

### VPC Attachment Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `create_transit_gateway_vpc_attachment` | Whether to create a VPC attachment | `bool` | `true` |
| `transit_gateway_subnet_ids` | Subnet IDs for the VPC attachment | `list(string)` | `[]` |
| `transit_gateway_vpc_attachment_name` | Name of the VPC attachment | `string` | `"main-tgw-vpc-attachment"` |
| `transit_gateway_appliance_mode_support` | Enable appliance mode support | `string` | `"disable"` |
| `transit_gateway_ipv6_support` | Enable IPv6 support | `string` | `"disable"` |

### Route Table Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `create_transit_gateway_route_table` | Whether to create a route table | `bool` | `true` |
| `transit_gateway_route_table_name` | Name of the route table | `string` | `"main-tgw-route-table"` |
| `create_transit_gateway_route_table_association` | Whether to create route table association | `bool` | `true` |
| `create_transit_gateway_route_table_propagation` | Whether to create route table propagation | `bool` | `true` |
| `transit_gateway_routes` | List of routes to add to the route table | `list(object({cidr_block = string}))` | `[]` |
| `transit_gateway_route_table_subnet_ids` | Subnet IDs to associate with route table | `list(string)` | `[]` |

### Logging and Monitoring

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `enable_vpn_connection_logging` | Enable VPN connection logging | `bool` | `false` |
| `vpn_connection_log_retention_days` | Days to retain VPN logs (1-3653) | `number` | `7` |

### Advanced Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `hybrid_config` | Advanced hybrid connectivity configuration | `object` | `{}` |
| `hybrid_monitoring_config` | Advanced monitoring configuration | `object` | `{}` |
| `hybrid_security_config` | Advanced security configuration | `object` | `{}` |
| `common_tags` | Common tags for all resources | `map(string)` | `{}` |

## 📤 Outputs

| Name | Description |
|------|-------------|
| `transit_gateway_id` | ID of the Transit Gateway |
| `transit_gateway_arn` | ARN of the Transit Gateway |
| `transit_gateway_route_table_id` | ID of the Transit Gateway route table |
| `transit_gateway_vpc_attachment_id` | ID of the VPC attachment |
| `customer_gateway_id` | ID of the Customer Gateway |
| `vpn_connection_id` | ID of the VPN connection |
| `vpn_connection_tunnel1_address` | Public IP address of tunnel 1 |
| `vpn_connection_tunnel2_address` | Public IP address of tunnel 2 |
| `direct_connect_gateway_id` | ID of the Direct Connect Gateway |
| `direct_connect_gateway_association_id` | ID of the Direct Connect Gateway association |

## 🔒 Security Considerations

### VPN Security
- Use strong preshared keys (8-64 characters)
- Configure strong encryption algorithms (AES256 recommended)
- Use strong integrity algorithms (SHA2-256 or higher)
- Enable VPN connection logging for monitoring
- Configure appropriate DPD timeout values

### Network Security
- Use private ASN ranges (64512-65534)
- Configure appropriate route table associations
- Enable DNS support only when required
- Use appliance mode for load balancer integration

### Access Control
- Implement least-privilege IAM policies
- Enable CloudWatch logging for audit trails
- Use resource tagging for cost allocation
- Configure appropriate retention policies

## 🚨 Important Notes

1. **ASN Configuration**: Use private ASN ranges (64512-65534) for Transit Gateway and Customer Gateway
2. **Subnet Requirements**: VPC attachment subnets must be in different Availability Zones
3. **Preshared Keys**: Must be 8-64 characters and should be strong and unique
4. **Route Propagation**: Ensure proper route table associations and propagations
5. **BGP vs Static Routes**: BGP is recommended for dynamic routing, static routes for simple setups

## 📚 Examples

See the `examples/` directory for complete working examples:

- **Basic**: Simple Transit Gateway with VPC attachment
- **Advanced**: Enterprise configuration with VPN, Direct Connect, and monitoring

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This module is licensed under the MIT License. See the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the documentation
2. Review existing issues
3. Create a new issue with detailed information

## 🔄 Version History

- **v2.0.0**: Enhanced with comprehensive customization options
- **v1.0.0**: Initial release with basic functionality