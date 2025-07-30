# AWS Hybrid Connectivity Architecture

This document provides detailed information about the hybrid connectivity architectures supported by this Terraform module.

## 🏗️ Architecture Overview

The module supports three main hybrid connectivity patterns:

### 1. Direct Connect + Transit Gateway

```
On-premises Network
       │
       ▼
┌─────────────────┐
│ Direct Connect  │
│   Connection    │
└─────────────────┘
       │
       ▼
┌─────────────────┐
│ Direct Connect  │
│    Gateway      │
└─────────────────┘
       │
       ▼
┌─────────────────┐
│   Transit       │
│   Gateway       │
└─────────────────┘
       │
       ▼
┌─────────────────┐
│   VPC 1         │
│   VPC 2         │
│   VPC 3         │
└─────────────────┘
```

**Characteristics:**
- **Bandwidth**: Up to 100 Gbps dedicated
- **Latency**: Predictable, low latency
- **Cost**: Fixed monthly cost + data transfer
- **Use Cases**: Mission-critical workloads, high-bandwidth requirements
- **Availability**: 99.99% uptime SLA

### 2. Site-to-Site VPN + Transit Gateway

```
On-premises Network
       │
       ▼
┌─────────────────┐
│   Internet      │
│   Connection    │
└─────────────────┘
       │
       ▼
┌─────────────────┐
│ Customer Gateway│
│   (On-premises) │
└─────────────────┘
       │
       ▼
┌─────────────────┐
│   VPN Gateway   │
└─────────────────┘
       │
       ▼
┌─────────────────┐
│   Transit       │
│   Gateway       │
└─────────────────┘
       │
       ▼
┌─────────────────┐
│   VPC 1         │
│   VPC 2         │
│   VPC 3         │
└─────────────────┘
```

**Characteristics:**
- **Bandwidth**: 1.25 Gbps per tunnel, up to 50 Gbps with ECMP
- **Latency**: Internet-dependent
- **Cost**: Pay-per-use data transfer
- **Use Cases**: Secure encrypted connectivity, disaster recovery
- **Availability**: Internet-dependent

### 3. Hybrid Failover Architecture

```
On-premises Network
       │
       ├─────────────────┐
       ▼                 ▼
┌─────────────┐    ┌─────────────┐
│   Direct    │    │   Internet  │
│  Connect    │    │  Connection │
└─────────────┘    └─────────────┘
       │                 │
       ▼                 ▼
┌─────────────┐    ┌─────────────┐
│ Direct      │    │ Customer    │
│ Connect     │    │ Gateway     │
│ Gateway     │    │(On-premises)│
└─────────────┘    └─────────────┘
       │                 │
       └─────────┬───────┘
                 ▼
        ┌─────────────┐
        │   Transit   │
        │   Gateway   │
        └─────────────┘
                 │
                 ▼
        ┌─────────────┐
        │   VPC 1     │
        │   VPC 2     │
        │   VPC 3     │
        └─────────────┘
```

**Characteristics:**
- **Primary**: Direct Connect for high-performance traffic
- **Backup**: VPN for failover and disaster recovery
- **Failover**: Automatic BGP-based failover
- **Availability**: 99.99% uptime for critical applications

## 🔧 Implementation Details

### Transit Gateway Configuration

The Transit Gateway serves as the central hub for all hybrid connectivity:

```hcl
resource "aws_ec2_transit_gateway" "main" {
  description                     = "Main Transit Gateway for hybrid connectivity"
  amazon_side_asn                 = 64512
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  auto_accept_shared_attachments  = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  multicast_support               = "disable"
}
```

**Key Features:**
- **ASN**: Private ASN (64512) for BGP routing
- **DNS Support**: Enables DNS resolution across VPCs
- **VPN ECMP**: Equal Cost Multipath for VPN tunnels
- **Route Tables**: Separate association and propagation tables

### Direct Connect Gateway

For Direct Connect connectivity:

```hcl
resource "aws_dx_gateway" "main" {
  name            = "main-dx-gateway"
  amazon_side_asn = 64512
}

resource "aws_dx_gateway_association" "main" {
  dx_gateway_id         = aws_dx_gateway.main.id
  associated_gateway_id = aws_ec2_transit_gateway.main.id
  allowed_prefixes      = ["10.0.0.0/16", "172.16.0.0/12"]
}
```

**Key Features:**
- **BGP ASN**: Amazon-side ASN for BGP sessions
- **Allowed Prefixes**: VPC CIDRs to advertise to on-premises
- **Association**: Links Direct Connect Gateway to Transit Gateway

### VPN Connection

For Site-to-Site VPN connectivity:

```hcl
resource "aws_customer_gateway" "main" {
  bgp_asn    = 65000
  ip_address = "203.0.113.1"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
  customer_gateway_id = aws_customer_gateway.main.id
  transit_gateway_id  = aws_ec2_transit_gateway.main.id
  type                = "ipsec.1"
  
  tunnel1_preshared_key = var.vpn_tunnel1_preshared_key
  tunnel2_preshared_key = var.vpn_tunnel2_preshared_key
  
  # Strong encryption and integrity algorithms
  tunnel1_phase1_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  tunnel1_phase2_encryption_algorithms = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
}
```

**Key Features:**
- **Dual Tunnels**: Two VPN tunnels for high availability
- **Strong Encryption**: AES128/AES256 with SHA2 algorithms
- **BGP Support**: Dynamic routing with on-premises network
- **Dead Peer Detection**: Automatic tunnel recovery

### VPC Attachment

Connecting VPCs to the Transit Gateway:

```hcl
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids         = var.transit_gateway_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.vpc_id
  
  appliance_mode_support = "disable"
  dns_support            = "enable"
  ipv6_support           = "disable"
}
```

**Key Features:**
- **Multi-AZ**: Subnets across multiple Availability Zones
- **DNS Support**: DNS resolution across VPCs
- **Appliance Mode**: Optional for traffic inspection

## 🛡️ Security Considerations

### Network Security

1. **Private Connectivity**: Direct Connect provides private connectivity
2. **Encrypted VPN**: All VPN traffic is encrypted
3. **Route Isolation**: Separate route tables for different VPCs
4. **Security Groups**: Instance-level security controls

### IAM Security

1. **Least Privilege**: Minimal IAM roles for VPN logging
2. **Role-Based Access**: CloudWatch logging with specific permissions
3. **Secure Keys**: Preshared keys marked as sensitive

### Monitoring and Logging

1. **VPN Logging**: CloudWatch logs for VPN connection events
2. **Health Monitoring**: BGP-based health checks
3. **Alerting**: CloudWatch alarms for connection status

## 📊 Performance Characteristics

### Direct Connect Performance

| Metric | Value |
|--------|-------|
| Bandwidth | Up to 100 Gbps |
| Latency | < 1ms (same region) |
| Availability | 99.99% |
| Jitter | Minimal |

### VPN Performance

| Metric | Value |
|--------|-------|
| Bandwidth | 1.25 Gbps per tunnel |
| Latency | Internet-dependent |
| Availability | Internet-dependent |
| Jitter | Variable |

### Transit Gateway Performance

| Metric | Value |
|--------|-------|
| Throughput | Up to 50 Gbps per attachment |
| Latency | < 1ms |
| Availability | 99.99% |
| Connections | Up to 5,000 VPCs |

## 💰 Cost Optimization

### Direct Connect Costs

- **Connection**: $0.30 per hour (~$216/month)
- **Data Transfer**: $0.02 per GB (outbound)
- **Port Hours**: $0.30 per hour

### VPN Costs

- **Data Transfer**: $0.05 per GB (outbound)
- **No hourly charges**

### Transit Gateway Costs

- **Attachment**: $0.05 per hour (~$36/month per VPC)
- **Data Processing**: $0.02 per GB

### Cost Comparison

| Scenario | Monthly Cost (1TB) |
|----------|-------------------|
| Direct Connect | ~$236 |
| VPN Only | ~$51 |
| Hybrid (DC + VPN) | ~$287 |

## 🔄 Failover Mechanisms

### BGP-Based Failover

1. **Primary Route**: Direct Connect (lower AS path)
2. **Backup Route**: VPN (higher AS path)
3. **Automatic Switch**: BGP convergence on failure
4. **Recovery**: Automatic restoration when primary returns

### Health Monitoring

1. **BGP Keepalives**: Continuous BGP session monitoring
2. **VPN Tunnel Status**: AWS monitors VPN tunnel health
3. **Route Propagation**: Automatic route updates
4. **CloudWatch Alarms**: Proactive monitoring and alerting

## 🚀 Deployment Scenarios

### Startup (1-50 employees)

**Recommended Pattern**: VPN + Transit Gateway
- **Cost**: ~$50-100/month
- **Setup Time**: 1-2 hours
- **Complexity**: Low
- **Use Case**: Development and testing

### SMB (50-500 employees)

**Recommended Pattern**: VPN + Transit Gateway + VPC Endpoints
- **Cost**: ~$100-300/month
- **Setup Time**: 4-8 hours
- **Complexity**: Medium
- **Use Case**: Production workloads

### Enterprise (500+ employees)

**Recommended Pattern**: Direct Connect + VPN Backup + Multi-VPC
- **Cost**: ~$300-1000+/month
- **Setup Time**: 1-2 weeks
- **Complexity**: High
- **Use Case**: Mission-critical applications

## 🔧 Configuration Examples

### Basic VPN Setup

```hcl
module "hybrid_connectivity" {
  source = "./tfm-aws-tgw-hybrid"
  
  vpc_id = "vpc-12345678"
  
  create_transit_gateway = true
  create_customer_gateway = true
  create_vpn_connection = true
  
  customer_gateway_ip_address = "203.0.113.1"
  vpn_tunnel1_preshared_key = "your-key-1"
  vpn_tunnel2_preshared_key = "your-key-2"
}
```

### Enterprise Hybrid Setup

```hcl
module "hybrid_connectivity" {
  source = "./tfm-aws-tgw-hybrid"
  
  vpc_id = "vpc-12345678"
  
  # Transit Gateway
  create_transit_gateway = true
  
  # Direct Connect (Primary)
  create_direct_connect_gateway = true
  direct_connect_allowed_prefixes = ["10.0.0.0/16"]
  
  # VPN (Backup)
  create_customer_gateway = true
  create_vpn_connection = true
  customer_gateway_ip_address = "203.0.113.1"
  
  # Logging
  enable_vpn_connection_logging = true
  vpn_connection_log_retention_days = 30
}
```

## 📈 Scaling Considerations

### Horizontal Scaling

1. **Multiple VPCs**: Add VPC attachments as needed
2. **Multiple VPNs**: Create additional VPN connections
3. **Multiple Direct Connect**: Add additional connections

### Vertical Scaling

1. **Direct Connect**: Upgrade to higher bandwidth connections
2. **VPN**: Use ECMP for multiple tunnels
3. **Transit Gateway**: Optimize route table configurations

### Performance Tuning

1. **Route Optimization**: Minimize route table entries
2. **BGP Tuning**: Optimize BGP timers and policies
3. **Monitoring**: Implement comprehensive monitoring

This architecture provides a robust foundation for hybrid connectivity that can scale from small startups to large enterprises while maintaining security, performance, and cost-effectiveness. 