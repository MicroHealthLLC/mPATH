variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
variable "twingate_secret_path" {
  description = "Path to the Twingate secret in AWS Secrets Manager"
  type        = string
}

# Optional KMS key(s) for encrypting secrets (used by ECS exec policy, etc.)
variable "kms_key_id" {
  description = "Optional KMS key for encrypting the RDS secret or other app secrets."
  type        = string
  default     = null
}

variable "kms_key_arns" {
  description = "Optional list of KMS key ARNs used to encrypt Secrets Manager secrets."
  type        = list(string)
  default     = []
}



variable "enable_log_encryption" {
  description = "Whether to enable KMS encryption on CloudWatch Logs."
  type        = bool
  default     = false
}

variable "log_kms_key_id" {
  description = "KMS key ID/ARN to use for CloudWatch Logs encryption when enable_log_encryption is true."
  type        = string
  default     = null
}


variable "cpu" {
  description = "CPU units for the ECS task (256, 512, 1024, etc.)"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory for the ECS task (in MB)"
  type        = number
  default     = 1024
}


variable "env" {
  description = "Short env name (e.g., bo, qa, prod)"
  type        = string
}

variable "readonly_root_filesystem" {
  type        = bool
  default     = true
  description = "Whether to make the container's root filesystem read-only."
}