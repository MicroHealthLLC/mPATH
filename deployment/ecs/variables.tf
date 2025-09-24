variable "environment" {
  description = "Environment name (e.g., Development, Staging, Production)"
  type        = string
  default     = "Production"

  validation {
    condition     = contains(["Development", "Staging", "Production"], var.environment)
    error_message = "Environment must be one of: Development, Staging, Production."
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least 2 availability zones must be specified for high availability."
  }
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "mpath-production-vpc"

  validation {
    condition     = length(var.vpc_name) > 0 && length(var.vpc_name) <= 255
    error_message = "VPC name must be between 1 and 255 characters long."
  }
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "192.168.29.0/24"
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listeners"
  type        = string
}

variable "internet_gateway_name" {
  description = "Name of the Internet Gateway"
  type        = string
  default     = "mpath-production-igw"

  validation {
    condition     = length(var.internet_gateway_name) > 0 && length(var.internet_gateway_name) <= 255
    error_message = "Internet Gateway name must be between 1 and 255 characters long."
  }
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
  default     = "mpath-production-nat-gateway"

  validation {
    condition     = length(var.nat_gateway_name) > 0 && length(var.nat_gateway_name) <= 255
    error_message = "NAT Gateway name must be between 1 and 255 characters long."
  }
}

variable "aws_account_id" {
  description = "AWS Account ID for ECR repository"
  type        = string
}

variable "container_image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "CPU units for the ECS task"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory for the ECS task in MB"
  type        = number
  default     = 1024
}

variable "database_url" {
  description = "Database connection URL"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Application secret key"
  type        = string
  sensitive   = true
}

variable "bw_org_id" {
  description = "Bitwarden Organization ID"
  type        = string
  sensitive   = true
}

variable "bw_access_token" {
  description = "Bitwarden Access Token"
  type        = string
  sensitive   = true
}

variable "bw_project_id" {
  description = "Bitwarden Project ID"
  type        = string
  sensitive   = true
}

variable "postgres_database" {
  type        = string
  description = "The name of the database"
  sensitive   = true
}

variable "postgres_username" {
  type        = string
  description = "The username for the database"
  sensitive   = true
}

variable "postgres_password" {
  type        = string
  description = "The password for the database"
  sensitive   = true
}

variable "identifier" {
  type        = string
  description = "The identifier for the RDS instance"
  sensitive   = true
}

variable "instance_class" {
  description = "The instance class to use for the RDS instance."
  type        = string
  default     = "db.m5.large"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.m5.xlarge"

  validation {
    condition     = can(regex("^db\\.", var.rds_instance_class))
    error_message = "RDS instance class must start with 'db.'"
  }
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 250

  validation {
    condition     = var.rds_allocated_storage >= 20 && var.rds_allocated_storage <= 65536
    error_message = "RDS allocated storage must be between 20 GB and 65536 GB."
  }
}

# RDS CloudWatch Logging Variables
variable "rds_enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch for RDS"
  type        = list(string)
  default     = ["postgresql"]
}

variable "rds_performance_insights_enabled" {
  description = "Enable Performance Insights for RDS"
  type        = bool
  default     = true
}

variable "rds_performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data"
  type        = number
  default     = 7
}

variable "rds_monitoring_interval" {
  description = "The interval for collecting enhanced monitoring metrics"
  type        = number
  default     = 60
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "ecs_log_retention_days" {
  description = "CloudWatch log retention period in days for ECS"
  type        = number
  default     = 30
}

variable "ecs_health_check_enabled" {
  description = "Enable health checks for ECS containers"
  type        = bool
  default     = true
}

variable "ecs_health_check_path" {
  description = "Health check path for the application"
  type        = string
  default     = "/health"
}

variable "ecs_assign_public_ip" {
  description = "Assign public IP to ECS tasks"
  type        = bool
  default     = true
}

variable "ecs_platform_version" {
  description = "ECS platform version"
  type        = string
  default     = "LATEST"
}

variable "ecs_deployment_maximum_percent" {
  description = "Upper limit on the number of running tasks during deployment"
  type        = number
  default     = 200
}

variable "ecs_deployment_minimum_healthy_percent" {
  description = "Lower limit on the number of running tasks during deployment"
  type        = number
  default     = 50
}

variable "ecs_deployment_circuit_breaker_enabled" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "ecs_deployment_circuit_breaker_rollback" {
  description = "Enable rollback on deployment failure"
  type        = bool
  default     = true
}

variable "ecs_container_insights_enabled" {
  description = "Enable container insights for the ECS cluster"
  type        = bool
  default     = true
}

variable "alb_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = true
}

variable "alb_ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "waf_allowed_countries" {
  description = "List of allowed country codes for WAF geo restriction"
  type        = list(string)
  default     = ["US"]
}