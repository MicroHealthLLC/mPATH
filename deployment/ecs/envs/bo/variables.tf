variable "aws_region" { type = string }

# Container / service
variable "container_image"   { type = string }
variable "container_port"    { type = number  default = 8443 }  # app listens on 8443
variable "desired_count"     { type = number  default = 2 }
variable "cpu"               { type = number  default = 512 }
variable "memory"            { type = number  default = 1024 }
variable "health_check_path" { type = string  default = "/health" }

# TLS for ALB
variable "acm_certificate_arn" { type = string }
variable "ssl_policy"          { type = string  default = "ELBSecurityPolicy-TLS-1-2-2017-01" }

# deployments
variable "log_retention_days"                { type = number default = 30 }
variable "platform_version"                  { type = string default = "LATEST" }
variable "deployment_maximum_percent"        { type = number default = 200 }
variable "deployment_minimum_healthy_percent"{ type = number default = 50 }
variable "deployment_circuit_breaker_enabled"{ type = bool   default = true }
variable "deployment_circuit_breaker_rollback"{ type = bool  default = true }

variable "tags" {
  type    = map(string)
  default = {}
}
