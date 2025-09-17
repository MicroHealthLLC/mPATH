# AWS Configuration
aws_account_id = "2"  # Replace with your AWS account ID

# Application Configuration
environment = "Production"
container_image_tag = "latest"


# ECS Configuration
desired_count = 2
cpu = 1024
memory = 2048

# Security Configuration
secret_key = "your-secure-secret-key-here"  # Generate a secure key

# AWS Region Configuration
aws_region         = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]

# VPC Configuration
vpc_name              = "mpath-production-vpc"
vpc_cidr_block        = "192.168.29.0/24"
internet_gateway_name = "mpath-production-igw"
nat_gateway_name      = "mpath-production-nat-gateway"

# SSL Certificate
certificate_arn = ""

# Tags
tags = {
  Owner       = "DevOps Team"
  CostCenter  = "Engineering"
  Application = "HealthMetricsAI"
}

# ECS Configuration
ecs_log_retention_days                     = 30
ecs_health_check_enabled                   = true
ecs_health_check_path                      = "/health"
ecs_assign_public_ip                       = false
ecs_platform_version                       = "LATEST"
ecs_deployment_maximum_percent             = 200
ecs_deployment_minimum_healthy_percent     = 50
ecs_deployment_circuit_breaker_enabled     = true
ecs_deployment_circuit_breaker_rollback    = true
ecs_container_insights_enabled             = true

# ALB Configuration
alb_deletion_protection = true
alb_ssl_policy         = "ELBSecurityPolicy-TLS-1-2-2017-01"

# WAF Configuration
waf_allowed_countries = ["US"]