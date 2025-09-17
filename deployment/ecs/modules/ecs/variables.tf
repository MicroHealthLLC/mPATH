variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "container_image" {
  description = "Docker image URI"
  type        = string
}

variable "container_port" {
  description = "Port the container exposes"
  type        = number
  default     = 7860
}

variable "desired_count" {
  description = "Desired number of running tasks"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "CPU units for the task (256, 512, 1024, etc.)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the task in MB"
  type        = number
  default     = 512
}

variable "vpc_id" {
  description = "VPC ID where ECS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the ECS service"
  type        = list(string)
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 30
}

variable "health_check_enabled" {
  description = "Enable health checks for containers"
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Health check path for the application"
  type        = string
  default     = "/health"
}

variable "assign_public_ip" {
  description = "Assign public IP to ECS tasks"
  type        = bool
  default     = true
}

variable "platform_version" {
  description = "ECS platform version"
  type        = string
  default     = "LATEST"
}

variable "deployment_maximum_percent" {
  description = "Upper limit on the number of running tasks during deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit on the number of running tasks during deployment"
  type        = number
  default     = 50
}

variable "deployment_circuit_breaker_enabled" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "deployment_circuit_breaker_rollback" {
  description = "Enable rollback on deployment failure"
  type        = bool
  default     = true
}

variable "container_insights_enabled" {
  description = "Enable container insights for the ECS cluster"
  type        = bool
  default     = true
}

variable "target_group_arn" {
  description = "ARN of the load balancer target group"
  type        = string
  default     = null
}