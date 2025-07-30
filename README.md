# AWS Hybrid Connectivity Module

A comprehensive Terraform module for implementing hybrid connectivity patterns in AWS, supporting Direct Connect, Transit Gateway, Site-to-Site VPN, and failover scenarios.

## 🏗️ Architecture Patterns

This module supports the following hybrid connectivity architectures:

### 1. Direct Connect + Transit Gateway
```
On-premises → Direct Connect Gateway → Transit Gateway → Multiple VPCs
```
- **Use Cases**: Mission-critical workloads, high-bandwidth requirements
- **Performance**: Up to 100 Gbps dedicated bandwidth
- **Benefits**: Predictable performance, reduced costs for high-volume transfer

### 2. Site-to-Site VPN + Transit Gateway
```
On-premises → VPN Gateway → Transit Gateway → VPCs
```
- **Use Cases**: Secure encrypted connectivity, disaster recovery
- **Performance**: 1.25 Gbps per tunnel, up to 50 Gbps with ECMP
- **Benefits**: Quick setup, encrypted traffic, cost-effective

### 3. Hybrid Connectivity with Failover
```
Primary: Direct Connect, Backup: Site-to-Site VPN
```
- **Use Cases**: High availability hybrid connectivity
- **Failover**: Automatic BGP-based failover
- **Resilience**: 99.99% uptime for critical applications

## 🚀 Features

- **Modular Design**: Enable/disable components as needed
- **High Availability**: Built-in failover capabilities
- **Security**: VPN encryption, IAM roles, CloudWatch logging
- **Monitoring**: VPN connection logging and health checks
- **Flexible Routing**: Support for static and dynamic routing
- **Multi-VPC Support**: Connect multiple VPCs through Transit Gateway
- **Cost Optimization**: Conditional resource creation

## 📋 Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## 🔧 Usage

### Basic Transit Gateway Setup

```hcl
module "hybrid_connectivity" {
  source = "./tfm-aws-tgw-hybrid"

  vpc_id = "vpc-12345678"
  
  # Transit Gateway Configuration
  create_transit_gateway = true
  transit_gateway_name   = "main-tgw"
  
  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]
  
  # Route Table
  create_transit_gateway_route_table = true
  transit_gateway_route_table_subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]
  
  common_tags = {
    Environment = "production"
    Project     = "hybrid-connectivity"
  }
}
```

### Direct Connect + Transit Gateway

```hcl
module "hybrid_connectivity" {
  source = "./tfm-aws-tgw-hybrid"

  vpc_id = "vpc-12345678"
  
  # Transit Gateway
  create_transit_gateway = true
  transit_gateway_name   = "main-tgw"
  
  # Direct Connect Gateway
  create_direct_connect_gateway = true
  direct_connect_gateway_name   = "main-dx-gateway"
  direct_connect_gateway_asn    = 64512
  
  # Direct Connect Association
  create_direct_connect_gateway_association = true
  direct_connect_allowed_prefixes = [
    "10.0.0.0/16",
    "172.16.0.0/12"
  ]
  
  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]
  
  common_tags = {
    Environment = "production"
    Project     = "direct-connect"
  }
}
```

### Site-to-Site VPN + Transit Gateway

```hcl
module "hybrid_connectivity" {
  source = "./tfm-aws-tgw-hybrid"

  vpc_id = "vpc-12345678"
  
  # Transit Gateway
  create_transit_gateway = true
  transit_gateway_name   = "main-tgw"
  
  # Customer Gateway
  create_customer_gateway = true
  customer_gateway_name   = "on-premises-gateway"
  customer_gateway_bgp_asn = 65000
  customer_gateway_ip_address = "203.0.113.1"
  
  # VPN Connection
  create_vpn_connection = true
  vpn_connection_name    = "main-vpn-connection"
  vpn_static_routes_only = false
  vpn_tunnel1_preshared_key = "your-preshared-key-1"
  vpn_tunnel2_preshared_key = "your-preshared-key-2"
  
  # VPN Logging
  enable_vpn_connection_logging = true
  vpn_connection_log_retention_days = 30
  
  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]
  
  common_tags = {
    Environment = "production"
    Project     = "vpn-connectivity"
  }
}
```

### Hybrid Failover Setup

```hcl
module "hybrid_connectivity" {
  source = "./tfm-aws-tgw-hybrid"

  vpc_id = "vpc-12345678"
  
  # Transit Gateway
  create_transit_gateway = true
  transit_gateway_name   = "main-tgw"
  
  # Direct Connect Gateway (Primary)
  create_direct_connect_gateway = true
  direct_connect_gateway_name   = "main-dx-gateway"
  direct_connect_gateway_asn    = 64512
  
  create_direct_connect_gateway_association = true
  direct_connect_allowed_prefixes = [
    "10.0.0.0/16",
    "172.16.0.0/12"
  ]
  
  # Customer Gateway (Backup)
  create_customer_gateway = true
  customer_gateway_name   = "on-premises-gateway"
  customer_gateway_bgp_asn = 65000
  customer_gateway_ip_address = "203.0.113.1"
  
  # VPN Connection (Backup)
  create_vpn_connection = true
  vpn_connection_name    = "backup-vpn-connection"
  vpn_static_routes_only = false
  vpn_tunnel1_preshared_key = "your-preshared-key-1"
  vpn_tunnel2_preshared_key = "your-preshared-key-2"
  
  # VPC Attachment
  create_transit_gateway_vpc_attachment = true
  transit_gateway_subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]
  
  # Route Table
  create_transit_gateway_route_table = true
  transit_gateway_route_table_subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]
  
  transit_gateway_routes = [
    {
      cidr_block = "10.0.0.0/16"
    },
    {
      cidr_block = "172.16.0.0/12"
    }
  ]
  
  common_tags = {
    Environment = "production"
    Project     = "hybrid-failover"
  }
}
```

## 📖 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| common_tags | Common tags to apply to all resources | `map(string)` | `{}` | no |
| vpc_id | VPC ID for the hybrid connectivity setup | `string` | n/a | yes |
| create_transit_gateway | Whether to create a Transit Gateway | `bool` | `true` | no |
| transit_gateway_name | Name of the Transit Gateway | `string` | `"main-transit-gateway"` | no |
| transit_gateway_description | Description of the Transit Gateway | `string` | `"Main Transit Gateway for hybrid connectivity"` | no |
| transit_gateway_asn | Private Autonomous System Number (ASN) for the Transit Gateway | `number` | `64512` | no |
| create_direct_connect_gateway | Whether to create a Direct Connect Gateway | `bool` | `false` | no |
| direct_connect_gateway_name | Name of the Direct Connect Gateway | `string` | `"main-dx-gateway"` | no |
| direct_connect_gateway_asn | The Autonomous System Number (ASN) for the Amazon side of a BGP session | `number` | `64512` | no |
| create_customer_gateway | Whether to create a Customer Gateway | `bool` | `false` | no |
| customer_gateway_name | Name of the Customer Gateway | `string` | `"main-customer-gateway"` | no |
| customer_gateway_bgp_asn | The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN) | `number` | `65000` | no |
| customer_gateway_ip_address | The IP address of the gateway's Internet-routable external interface | `string` | `""` | no |
| create_vpn_connection | Whether to create a VPN Connection | `bool` | `false` | no |
| vpn_connection_name | Name of the VPN Connection | `string` | `"main-vpn-connection"` | no |
| vpn_static_routes_only | Whether the VPN connection uses static routes exclusively | `bool` | `false` | no |
| vpn_static_routes | List of CIDR blocks for static routes | `list(string)` | `[]` | no |
| vpn_tunnel1_preshared_key | The preshared key of the first VPN tunnel | `string` | `""` | no |
| vpn_tunnel2_preshared_key | The preshared key of the second VPN tunnel | `string` | `""` | no |
| enable_vpn_connection_logging | Whether to enable VPN connection logging to CloudWatch | `bool` | `false` | no |
| vpn_connection_log_retention_days | Number of days to retain VPN connection logs | `number` | `7` | no |
| create_transit_gateway_vpc_attachment | Whether to create a Transit Gateway VPC attachment | `bool` | `true` | no |
| transit_gateway_subnet_ids | List of subnet IDs for the Transit Gateway VPC attachment | `list(string)` | `[]` | no |
| create_transit_gateway_route_table | Whether to create a Transit Gateway route table | `bool` | `true` | no |
| transit_gateway_route_table_subnet_ids | List of subnet IDs to associate with the Transit Gateway route table | `list(string)` | `[]` | no |
| transit_gateway_routes | List of routes to add to the Transit Gateway route table | `list(object({cidr_block = string}))` | `[]` | no |

## 📤 Outputs

| Name | Description |
|------|-------------|
| transit_gateway_id | The ID of the Transit Gateway |
| transit_gateway_arn | The ARN of the Transit Gateway |
| direct_connect_gateway_id | The ID of the Direct Connect Gateway |
| direct_connect_gateway_arn | The ARN of the Direct Connect Gateway |
| customer_gateway_id | The ID of the Customer Gateway |
| vpn_connection_id | The ID of the VPN Connection |
| vpn_connection_tunnel1_address | The public IP address of the first VPN tunnel |
| vpn_connection_tunnel2_address | The public IP address of the second VPN tunnel |
| transit_gateway_vpc_attachment_id | The ID of the Transit Gateway VPC attachment |
| hybrid_connectivity_summary | Summary of the hybrid connectivity setup |

## 🔒 Security Considerations

### VPN Security
- Uses strong encryption algorithms (AES128/AES256)
- Supports SHA2-256/384/512 integrity algorithms
- Configurable preshared keys for both tunnels
- Dead Peer Detection (DPD) with restart action

### IAM Security
- Least privilege access for VPN logging
- Role-based access control for CloudWatch logging
- Secure handling of sensitive preshared keys

### Network Security
- Private connectivity through Direct Connect
- Encrypted VPN tunnels for backup connectivity
- Route table isolation and control

## 📊 Monitoring and Logging

### VPN Connection Logging
- CloudWatch log group for VPN connection events
- Configurable log retention period
- IAM role for secure logging access

### Health Monitoring
- BGP-based health checks for Direct Connect
- VPN tunnel status monitoring
- Automatic failover capabilities

## 💰 Cost Optimization

### Resource Optimization
- Conditional resource creation based on requirements
- Shared Transit Gateway for multiple VPCs
- Efficient routing through Transit Gateway

### Cost Considerations
- Direct Connect: Fixed monthly cost + data transfer
- VPN: Pay-per-use data transfer
- Transit Gateway: Per-hour attachment fees
- CloudWatch: Log storage and ingestion costs

## 🚨 Troubleshooting

### Common Issues

1. **VPN Connection Not Establishing**
   - Verify preshared keys match on both sides
   - Check customer gateway IP address
   - Ensure BGP ASN configuration is correct

2. **Direct Connect Not Working**
   - Verify Direct Connect connection status
   - Check BGP session establishment
   - Validate allowed prefixes configuration

3. **Transit Gateway Routing Issues**
   - Verify route table associations
   - Check route propagation settings
   - Ensure subnet configurations are correct

### Debugging Commands

```bash
# Check VPN connection status
aws ec2 describe-vpn-connections --vpn-connection-ids vpn-12345678

# Verify Transit Gateway attachments
aws ec2 describe-transit-gateway-attachments --filters "Name=transit-gateway-id,Values=tgw-12345678"

# Check Direct Connect connections
aws directconnect describe-connections --connection-id dxcon-12345678
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This module is licensed under the MIT License. See the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review AWS documentation for specific services

## 🔗 Related Modules

- [AWS VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc)
- [AWS Security Groups Module](https://github.com/terraform-aws-modules/terraform-aws-security-group)
- [AWS Load Balancer Module](https://github.com/terraform-aws-modules/terraform-aws-alb)