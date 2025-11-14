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
  description = "CPU units for the task"
  type        = number
  default     = 2048
}

variable "memory" {
  description = "Memory for the task in MB"
  type        = number
  default     = 4096
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

  validation {
    condition     = !var.create_alb || (length(var.public_subnet_ids) > 0 && length(trimspace(var.acm_certificate_arn)) > 0)
    error_message = "When create_alb = true, you must provide public_subnet_ids and acm_certificate_arn."
  }

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
  # Consider: "ELBSecurityPolicy-TLS13-1-2-2021-06" for modern clients
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "alb_name" {
  description = "Optional explicit ALB name; if null, the module will use <service_name>-alb."
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

variable "target_group_arn" {
  description = "Optional existing Target Group ARN to attach ECS service to; if null, the module-created TG is used."
  type        = string
  default     = null
}

variable "db_secret_arn" {
  type    = string
  default = null
}

variable "app_secret_arn" {
  type    = string
  default = null
}


variable "kms_key_arns" {
  type        = list(string)
  default     = []
  description = "Optional list of KMS key ARNs used to encrypt the secrets; grants kms:Decrypt to the execution role."
}

variable "microsoft_secret_path" {
  type        = string
  description = "Path to the Microsoft OAuth JSON secret in AWS Secrets Manager"
  default     = null
}

variable "readonly_root_filesystem" {
  type        = bool
  default     = true
  description = "Whether to make the container's root filesystem read-only."
}

variable "mpath_exec" {
  description = "Enable exec"
  type        = bool
  default     = false
}

variable "custom_domain_name" {
  description = "The domain allowed to access the ALB"
  type        = string
}
