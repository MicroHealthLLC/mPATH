variable "service_name" {
  description = "Name of the Twingate connector service"
  type        = string
  default     = "twingate-ecs-connector-2"
}

variable "container_image" {
  description = "Docker image for the Twingate connector"
  type        = string
  default     = "twingate/connector:1"
}

variable "cpu" {
  description = "CPU units for the Twingate connector task"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "Memory (MB) for the Twingate connector task"
  type        = number
  default     = 2048
}

variable "desired_count" {
  description = "Number of Twingate connector tasks to run"
  type        = number
  default     = 1
}

variable "cluster_id" {
  description = "ECS cluster ID where the Twingate connector will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Twingate connector will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Twingate connector"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to the Twingate connector task"
  type        = bool
  default     = false
}

variable "platform_version" {
  description = "ECS platform version"
  type        = string
  default     = "LATEST"
}

variable "deployment_maximum_percent" {
  description = "Maximum deployment percentage"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy deployment percentage"
  type        = number
  default     = 100
}

variable "deployment_circuit_breaker_enabled" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "deployment_circuit_breaker_rollback" {
  description = "Enable deployment circuit breaker rollback"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 30
}

variable "enable_log_encryption" {
  description = "Enable CloudWatch log encryption"
  type        = bool
  default     = false
}

variable "log_kms_key_id" {
  description = "KMS key ID for CloudWatch log encryption"
  type        = string
  default     = null
}

variable "readonly_root_filesystem" {
  description = "Enable read-only root filesystem for container security"
  type        = bool
  default     = true
}

variable "twingate_label_deployed_by" {
  description = "Label indicating how the Twingate connector was deployed"
  type        = string
  default     = "ecs"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "twingate_secret_path" {
  description = "Path to the Twingate JSON secret in AWS Secrets Manager (e.g., mpath/bo/twingate)."
  type        = string
}

variable "twingate_exec" {
  description = "Enable exec"
  type        = bool
  default     = false
}