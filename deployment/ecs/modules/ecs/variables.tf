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
  default     = 8443  
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
  description = "PRIVATE subnet IDs for ECS tasks"
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
  default     = false
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

variable "create_alb" {
  description = "Create ALB/TG/listeners inside the module"
  type        = bool
  default     = false
}

variable "public_subnet_ids" {
  description = "PUBLIC subnet IDs for ALB (required if create_alb = true)"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener (required if create_alb = true)"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "TLS policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "alb_name" {
  description = "Name for the ALB (defaults to ${service_name}-alb)"
  type        = string
  default     = null
}

variable "alb_deletion_protection" {
  description = "Enable deletion protection on the ALB"
  type        = bool
  default     = true
}

variable "allowed_source_sg_ids" {
  description = "Security group IDs allowed to reach the ECS tasks on container_port (e.g., ALB SG). If empty, no SG ingress is created (unless ALB is created in-module)."
  type        = list(string)
  default     = []
}


validation {
  condition     = !(var.create_alb) || (length(var.public_subnet_ids) > 0 && length(var.acm_certificate_arn) > 0)
  error_message = "When create_alb = true, you must provide public_subnet_ids and acm_certificate_arn."
}
