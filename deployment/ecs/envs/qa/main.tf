terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  backend "s3" {} # init with: terraform init -backend-config=backend.hcl
}

provider "aws" {
  region = var.aws_region
}

locals {
  app_name = "mpath"
  env      = var.environment
}


# Pull shared network from the ROOT stack
data "terraform_remote_state" "root" {
  backend = "s3"
  config = {
    bucket  = "mpath-terraform-remote-state"
    key     = "mpath/vpc/terraform.tfstate"
    region  = var.aws_region
    encrypt = true
  }
}

locals {
  vpc_id             = data.terraform_remote_state.root.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.root.outputs.private_subnet_ids
  public_subnet_ids  = data.terraform_remote_state.root.outputs.public_subnet_ids

  tags = {
    Project     = local.app_name
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}


data "aws_secretsmanager_secret_version" "mpath_cert" {
  secret_id = "/mpath/acm/cert-arn"
}

locals {
  _raw_cert_string = data.aws_secretsmanager_secret_version.mpath_cert.secret_string
  _maybe_json      = try(jsondecode(local._raw_cert_string), null)
  _json_cert_arn   = local._maybe_json == null ? "" : try(local._maybe_json.cert_arn, "")
  acm_cert_from_sm = local._json_cert_arn != "" ? local._json_cert_arn : local._raw_cert_string

  # Final selection: explicit var wins; else Secrets Manager
  selected_acm_cert_arn = var.acm_certificate_arn != "" ? var.acm_certificate_arn : local.acm_cert_from_sm
  # Or, if you’re worried about whitespace:
  # selected_acm_cert_arn = trimspace(var.acm_certificate_arn) != "" ? var.acm_certificate_arn : local.acm_cert_from_sm
}



module "ecs_service" {
  source = "../../modules/ecs"

  cluster_name   = "${local.app_name}-${local.env}"
  service_name   = "${local.app_name}-app-${local.env}"
  vpc_id         = local.vpc_id
  subnet_ids     = local.private_subnet_ids
  db_secret_arn  = aws_secretsmanager_secret.db.arn
  app_secret_arn = aws_secretsmanager_secret.app.arn
  # Container / service
  container_image   = var.container_image
  container_port    = var.container_port
  desired_count     = var.desired_count
  cpu               = var.cpu
  memory            = var.memory
  health_check_path = var.health_check_path
  mpath_exec = var.mpath_exec
  readonly_root_filesystem = true
  custom_domain_name = var.custom_domain_name
  environment_variables = {
  RAILS_ENV                = "production"
  RAILS_SERVE_STATIC_FILES = "true"
  NODE_ENV                 = "production"
  }

  # ALB/TG/listeners inside the module (per-env ALB)
  create_alb              = true
  public_subnet_ids       = local.public_subnet_ids
  alb_name                = "${local.app_name}-${local.env}-alb"
  alb_deletion_protection = true
  acm_certificate_arn     = local.selected_acm_cert_arn
  ssl_policy              = var.ssl_policy

  # Ops & deployments
  platform_version                    = var.platform_version
  deployment_maximum_percent          = var.deployment_maximum_percent
  deployment_minimum_healthy_percent  = var.deployment_minimum_healthy_percent
  deployment_circuit_breaker_enabled  = var.deployment_circuit_breaker_enabled
  deployment_circuit_breaker_rollback = var.deployment_circuit_breaker_rollback
  container_insights_enabled          = true
  log_retention_days                  = var.log_retention_days
  assign_public_ip                    = false
  microsoft_secret_path               = var.microsoft_secret_path
  tags                                = local.tags
}


# Discover this env’s ALB (created by module.ecs_service)
data "aws_lb" "qa_alb" {
  name       = "${local.app_name}-${local.env}-alb"
  depends_on = [module.ecs_service]
}

# Associate the root WAF to this ALB
resource "aws_wafv2_web_acl_association" "mpath_web_acl_assoc" {
  resource_arn = data.aws_lb.qa_alb.arn
  web_acl_arn  = data.terraform_remote_state.root.outputs.waf_web_acl_arn
}

resource "random_password" "secret_key_base" {
  length  = 64
  special = false
}

resource "aws_secretsmanager_secret" "app" {
  name        = "mpath/qa/app"
  description = "mPATH qa app env"
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id = aws_secretsmanager_secret.app.id
  secret_string = jsonencode({
    SECRET_KEY_BASE = random_password.secret_key_base.result
    # ...other keys...
  })
}


module "twingate_connector" {
  source = "../../modules/twingate-connector"

  # Network/cluster wiring
  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids
  cluster_id = module.ecs_service.cluster_id
  twingate_exec = var.twingate_exec
  # Place the connector in private subnets, no public IP
  assign_public_ip = false
  desired_count    = 1
  cpu              = 1024
  memory           = 2048

  twingate_secret_path = var.twingate_secret_path

  readonly_root_filesystem = true


  tags = merge(local.tags, { Service = "TwingateConnector" })
}

