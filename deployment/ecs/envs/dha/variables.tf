# =====================================================================
# Region
# =====================================================================
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "microsoft_secret_path" {
  type        = string
  description = "Path to the Microsoft OAuth JSON secret in AWS Secrets Manager (e.g., mpath/bo/microsoft)"
}

# =====================================================================
# Container / Service configuration
# =====================================================================
variable "container_image" {
  description = "ECR image URI for the ECS task"
  type        = string
}

variable "container_port" {
  description = "Port that the container exposes (must match app listener)"
  type        = number
  default     = 8443
}

variable "desired_count" {
  description = "Desired number of running ECS tasks"
  type        = number
  default     = 1
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

variable "health_check_path" {
  description = "Path used for ALB health checks"
  type        = string
  default     = "/users/sign_in"
}

# =====================================================================
# TLS / ALB configuration
# =====================================================================
variable "acm_certificate_arn" {
  description = "Optional ACM certificate ARN for the ALB. Leave blank to use Secrets Manager."
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "SSL policy to use for the ALB HTTPS listener"
  type        = string
  # Modern TLS 1.2/1.3 policy; adjust for legacy client support if needed
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

# =====================================================================
# ECS Deployment knobs
# =====================================================================
variable "log_retention_days" {
  description = "CloudWatch log retention (days)"
  type        = number
  default     = 30
}

variable "platform_version" {
  description = "Fargate platform version to use"
  type        = string
  default     = "LATEST"
}

variable "deployment_maximum_percent" {
  description = "Upper limit of tasks running during deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit of tasks running during deployment"
  type        = number
  default     = 50
}

variable "deployment_circuit_breaker_enabled" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "deployment_circuit_breaker_rollback" {
  description = "Enable rollback if deployment fails"
  type        = bool
  default     = true
}


variable "environment" {
  description = "Short env name (e.g., bo, dha, prod)"
  type        = string
  default     = "prod"
}

variable "alb_deletion_protection" {
  description = "Enable deletion protection on the ALB"
  type        = bool
  default     = true
}

variable "waf_allowed_countries" {
  description = "List of ISO country codes for WAF (unused unless explicitly wired)"
  type        = list(string)
  default     = []
}

############################
# RDS-specific variables
############################

variable "db_identifier" {
  description = "Unique identifier for the RDS instance."
  type        = string
  default     = "mpath-dha-mysql"
}

variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "mpath_prod"
}

variable "db_username" {
  description = "Database master or app username."
  type        = string
  default     = "mpath_admin"
}

variable "db_password" {
  description = "Optional DB password. If null, one will be auto-generated."
  type        = string
  default     = null
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Storage in GiB (gp2 minimum is 20)."
  type        = number
  default     = 20
}

variable "kms_key_id" {
  description = "Optional KMS key for encrypting the secret."
  type        = string
  default     = null
}

variable "secret_name" {
  description = "Secrets Manager name for DB credentials bundle."
  type        = string
  default     = "mpath/dha/db"
}

variable "tags" {
  description = "Common tags to apply to RDS resources."
  type        = map(string)
  default = {
    App = "mPATH"
    Env = "dha"
  }
}

variable "ecs_tasks_sg_name" {
  description = "Name of the ECS tasks security group to allow into MySQL. If null, uses a convention."
  type        = string
  default     = null
}

# ── Rails Environment ─────────────────────────────────────────
variable "rails_env" {
  type        = string
  default     = "production"
  description = "Rails environment (e.g., development, staging, production)"
}

variable "rails_log_to_stdout" {
  type        = bool
  default     = true
  description = "Enable Rails to log to STDOUT (for ECS/Docker environments)"
}

variable "rails_serve_static" {
  type        = bool
  default     = true
  description = "Serve static files directly from Rails"
}

variable "puma_port" {
  type        = number
  default     = 3000
  description = "Port that Puma web server listens on"
}

variable "web_concurrency" {
  type        = number
  default     = 2
  description = "Number of Puma worker processes"
}

variable "rails_max_threads" {
  type        = number
  default     = 5
  description = "Maximum number of threads per Puma worker"
}

variable "rails_min_threads" {
  type        = number
  default     = 2
  description = "Minimum number of threads per Puma worker"
}

# ── Secrets & Keys ────────────────────────────────────────────
variable "secret_key_base" {
  type        = string
  default     = null
  description = "Rails SECRET_KEY_BASE; if null, Terraform generates and stores one in Secrets Manager"
}

# ── Office 365 (SSO) ─────────────────────────────────────────
variable "office365_client_id" {
  type        = string
  default     = ""
  description = "Office 365 application client ID"
}

variable "office365_client_secret" {
  type        = string
  default     = ""
  description = "Office 365 application client secret"
}

variable "office365_redirect_uri" {
  type        = string
  default     = ""
  description = "Redirect URI for Office 365 OAuth2 flow"
}

variable "office365_provider_url" {
  type        = string
  default     = ""
  description = "Office 365 provider or authorization endpoint"
}

# ── Keycloak (SSO) ────────────────────────────────────────────
variable "keycloak_client_id" {
  type        = string
  default     = "your-keycloak-client-id"
  description = "Keycloak client ID"
}

variable "keycloak_client_secret" {
  type        = string
  default     = "your-keycloak-client-secret"
  description = "Keycloak client secret"
}

variable "keycloak_realm" {
  type        = string
  default     = "your-keycloak-realm"
  description = "Keycloak realm name"
}

variable "keycloak_server_url" {
  type        = string
  default     = "https://xx"
  description = "Base URL for your Keycloak server"
}

# ── SSL / HTTPS ──────────────────────────────────────────────
variable "use_ssl" {
  type        = bool
  default     = false
  description = "Enable SSL (HTTPS) for the application"
}

variable "mpath_exec" {
  type        = bool
  default = false
}

variable "custom_domain_name" {
  description = "The domain allowed to access the ALB"
  type        = string
}

variable "env" {
  description = "Environment or deployment prefix"
  type        = string
}

variable "readonly_root_filesystem" {
  type        = bool
  default     = false
  description = "Whether to make the container's root filesystem read-only."
}