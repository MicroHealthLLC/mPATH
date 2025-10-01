waf_alb_arns = [
  aws_lb.mpath_production_alb.arn
]

aws_region  = "us-east-1"
environment = "bo"  # your env code uses local.env = "bo"

# Container / service
container_image = "295669632222.dkr.ecr.us-east-1.amazonaws.com/microhealthllc/mpath-bo:latest"
container_port  = 8443
desired_count   = 2
cpu             = 1024
memory          = 2048

# Healthcheck
health_check_path = "/health"

# TLS / ALB
acm_certificate_arn     = ""  # ACM ARN
ssl_policy              = "ELBSecurityPolicy-TLS-1-2-2017-01"
alb_deletion_protection = true

# ECS deployment knobs
platform_version                   = "LATEST"
deployment_maximum_percent         = 200
deployment_minimum_healthy_percent = 50
deployment_circuit_breaker_enabled = true
deployment_circuit_breaker_rollback = true
log_retention_days                 = 30


waf_allowed_countries = ["US"]

# Tags
tags = {
  Owner       = "DevOps Team"
  CostCenter  = "Engineering"
  Application = "mpath"
}
