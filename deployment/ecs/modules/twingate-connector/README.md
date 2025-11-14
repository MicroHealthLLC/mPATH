# Twingate ECS Connector Module

This module deploys a Twingate connector as an ECS Fargate service in your AWS environment. The Twingate connector provides secure remote access to your private resources without requiring a VPN.

## Features

- Deploys Twingate connector as an ECS Fargate service
- Integrates with existing ECS cluster
- Runs in private subnets for enhanced security
- CloudWatch logging integration
- IAM roles with minimal required permissions
- Configurable resource allocation

## Usage

```hcl
module "twingate_connector" {
  source = "./modules/twingate-connector"
  
  cluster_id       = module.ecs.cluster_id
  vpc_id           = aws_vpc.main.id
  subnet_ids       = aws_subnet.private[*].id
  assign_public_ip = false

  # Twingate Configuration
  twingate_network        = "your-network-name"
  twingate_access_token   = "your-access-token"
  twingate_refresh_token  = "your-refresh-token"
  
  # Resource Configuration
  cpu           = 1024
  memory        = 2048
  desired_count = 1
  
  tags = {
    Environment = "Production"
    Service     = "TwingateConnector"
  }
}
```

## Configuration

### Required Variables

- `cluster_id`: ECS cluster ID where the connector will be deployed
- `vpc_id`: VPC ID for security group creation
- `subnet_ids`: List of subnet IDs (recommend private subnets)
- `twingate_network`: Your Twingate network name
- `twingate_access_token`: Twingate access token (sensitive)
- `twingate_refresh_token`: Twingate refresh token (sensitive)

### Optional Variables

- `service_name`: Name of the service (default: "twingate-ecs-connector-2")
- `container_image`: Docker image for Twingate connector (default: "twingate/connector:1")
- `cpu`: CPU units for the task (default: 1024)
- `memory`: Memory in MB for the task (default: 2048)
- `desired_count`: Number of tasks to run (default: 1)
- `assign_public_ip`: Whether to assign public IP (default: false)

## Security Considerations

1. **Private Subnets**: The connector is deployed in private subnets by default
2. **IAM Permissions**: Uses minimal IAM permissions for ECS execution
3. **Sensitive Variables**: Access and refresh tokens are marked as sensitive
4. **Security Groups**: Only allows outbound traffic for Twingate connectivity

## Deployment

1. Enable Twingate in your main configuration:
   ```hcl
   twingate_enabled = true
   ```

2. Set the required Twingate variables in your `terraform.tfvars`:
   ```hcl
   twingate_network = "your-network-name"
   twingate_access_token = "your-access-token"
   twingate_refresh_token = "your-refresh-token"
   ```

3. Deploy with Terraform:
   ```bash
   terraform plan
   terraform apply
   ```

## Outputs

- `task_definition_arn`: ARN of the Twingate connector task definition
- `service_arn`: ARN of the Twingate connector service
- `service_name`: Name of the Twingate connector service
- `security_group_id`: ID of the security group

## Troubleshooting

### Connector Not Starting
- Check CloudWatch logs: `/ecs/twingate-ecs-connector-2`
- Verify access and refresh tokens are valid
- Ensure network connectivity from private subnets

### Connection Issues
- Verify security group allows outbound traffic
- Check NAT Gateway configuration for private subnets
- Confirm Twingate network configuration

### Resource Issues
- Monitor CPU and memory utilization in CloudWatch
- Adjust `cpu` and `memory` variables if needed
- Consider scaling `desired_count` for high availability