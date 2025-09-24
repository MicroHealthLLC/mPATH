aws_region = "us-east-1"

# Container
container_image   = "295669632222.dkr.ecr.us-east-1.amazonaws.com/microhealthllc/mpath-bo:latest"
container_port    = 8443
desired_count     = 2
cpu               = 512
memory            = 1024
health_check_path = "/health"

# TLS for ALB
acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
ssl_policy          = "ELBSecurityPolicy-TLS-1-2-2017-01"

# Ops / deployments
log_retention_days                 = 30
platform_version                   = "LATEST"
deployment_maximum_percent         = 200
deployment_minimum_healthy_percent = 50
deployment_circuit_breaker_enabled = true
deployment_circuit_breaker_rollback= true

# Optional tags
tags = {
  Owner = "Microhealth_Platform"
}
