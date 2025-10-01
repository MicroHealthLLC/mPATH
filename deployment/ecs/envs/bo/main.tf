terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  backend "s3" {} # init with: terraform init -backend-config=backend.hcl
}

provider "aws" { region = var.aws_region }

locals {
  app_name = "mpath"
  env      = "bo"
}

# Pull shared network from the ROOT stack
data "terraform_remote_state" "root" {
  backend = "s3"
  config = {
    bucket         = "mpath-terraform-state"
    key            = "mpath/root/terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
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

module "ecs_service" {
  source = "../../modules/ecs"


  cluster_name = "${local.app_name}-${local.env}"
  service_name = "${local.app_name}-app-${local.env}"

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids     # ECS tasks -> private subnets

  # Container / service
  container_image   = var.container_image
  container_port    = var.container_port      # set to 8443 in terraform.tfvars
  desired_count     = var.desired_count
  cpu               = var.cpu
  memory            = var.memory
  health_check_path = var.health_check_path

  # Create ALB/TG/listeners *inside* the module (per-env ALB)
  create_alb          = true
  public_subnet_ids   = local.public_subnet_ids
  alb_name            = "${local.app_name}-${local.env}-alb"
  alb_deletion_protection = true
  acm_certificate_arn = var.acm_certificate_arn
  ssl_policy          = var.ssl_policy

  # Ops & deployments
  platform_version                      = var.platform_version
  deployment_maximum_percent            = var.deployment_maximum_percent
  deployment_minimum_healthy_percent    = var.deployment_minimum_healthy_percent
  deployment_circuit_breaker_enabled    = var.deployment_circuit_breaker_enabled
  deployment_circuit_breaker_rollback   = var.deployment_circuit_breaker_rollback
  container_insights_enabled            = true
  log_retention_days                    = var.log_retention_days
  assign_public_ip                      = false

  tags = local.tags
}

output "bo_alb_dns_name" {
  value = module.ecs_service.alb_dns_name
}

output "bo_target_group_arn" {
  value = module.ecs_service.target_group_arn_effective
}

output "bo_ecs_service_sg" {
  value = module.ecs_service.security_group_id
}

# Discover this env’s ALB (created by module.ecs_service)
data "aws_lb" "bo_alb" {
  name       = "${local.app_name}-${local.env}-alb"
  depends_on = [module.ecs_service]
}

# Associate the root WAF to this ALB
resource "aws_wafv2_web_acl_association" "mpath_web_acl_assoc" {
  resource_arn = data.aws_lb.bo_alb.arn
  web_acl_arn  = data.terraform_remote_state.root.outputs.waf_web_acl_arn
}

