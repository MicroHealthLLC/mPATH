terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    # Reference backend-prod.hcl (Command: terraform init -backend-config=backend-prod.hcl)
  }
}

provider "aws" {
  region = var.aws_region
}

# Local values
locals {
  app_name = "healthmetricsai"
  
  common_tags = merge(var.tags, {
    Project     = "HealthMetricsAI"
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = var.vpc_name
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = var.internet_gateway_name
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    Type = "Public"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, count.index + 10)
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-private-${count.index + 1}"
    Type = "Private"
  })
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = merge(local.common_tags, {
    Name = "${var.nat_gateway_name}-eip"
  })
  
  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(local.common_tags, {
    Name = var.nat_gateway_name
  })

  depends_on = [aws_internet_gateway.main]
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-public-rt"
  })
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-private-rt"
  })
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "${local.app_name}-rds-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for RDS database"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.ecs.security_group_id]
    description     = "PostgreSQL access from ECS"
  }

  # Add ingress rule for private subnet CIDR blocks as backup
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [for subnet in aws_subnet.private : subnet.cidr_block]
    description = "PostgreSQL access from private subnets"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(local.common_tags, {
    Name = "${local.app_name}-rds-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name_prefix = "${local.app_name}-alb-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for Application Load Balancer"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access from internet"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access from internet (redirects to HTTPS)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(local.common_tags, {
    Name = "${local.app_name}-alb-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Update ECS Security Group to allow ALB access
resource "aws_security_group_rule" "ecs_alb_ingress" {
  type                     = "ingress"
  from_port                = 7860
  to_port                  = 7860
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = module.ecs.security_group_id
  description              = "Allow ALB to access ECS service"
}

# Application Load Balancer
resource "aws_lb" "healthmetricsai_production_alb" {
  name               = "${local.app_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = var.alb_deletion_protection

  tags = merge(local.common_tags, {
    Name = "${local.app_name}-${var.environment}-alb"
  })
}

# Target Group for ECS Service
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${local.app_name}-${var.environment}-tg"
  port        = 7860
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = var.ecs_health_check_path
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = merge(local.common_tags, {
    Name = "${local.app_name}-${var.environment}-tg"
  })
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.healthmetricsai_production_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    
    forward {
      target_group {
        arn = aws_lb_target_group.ecs_tg.arn
      }
    }
  }

  tags = local.common_tags
}

# HTTP Listener (redirect to HTTPS)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.healthmetricsai_production_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = local.common_tags
}

# ECS Deployment
module "ecs" {
  source = "./modules/ecs"
  
  cluster_name     = "${local.app_name}-${var.environment}"
  service_name     = "${local.app_name}-service"
  container_image  = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/microhealthllc/healthmetricsai:${var.container_image_tag}"
  container_port   = 7860
  desired_count    = var.desired_count
  cpu              = var.cpu
  memory           = var.memory
  
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id  # Changed to private subnets
  
  environment_variables = {
    DATABASE_URL    = "postgresql://${var.postgres_username}:${var.postgres_password}@${module.rds.db_instance_endpoint}/${var.postgres_database}"
    SECRET_KEY      = var.secret_key
    BW_ORG_ID       = var.bw_org_id
    BW_ACCESS_TOKEN = var.bw_access_token
    BW_PROJECT_ID   = var.bw_project_id
  }
  
  # ECS Configuration Variables
  log_retention_days                      = var.ecs_log_retention_days
  health_check_enabled                    = var.ecs_health_check_enabled
  health_check_path                       = var.ecs_health_check_path
  assign_public_ip                        = false  # Changed to false since we're in private subnets
  platform_version                        = var.ecs_platform_version
  deployment_maximum_percent              = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent      = var.ecs_deployment_minimum_healthy_percent
  deployment_circuit_breaker_enabled      = var.ecs_deployment_circuit_breaker_enabled
  deployment_circuit_breaker_rollback     = var.ecs_deployment_circuit_breaker_rollback
  container_insights_enabled              = var.ecs_container_insights_enabled
  
  # ALB Target Group ARN for service discovery
  target_group_arn = aws_lb_target_group.ecs_tg.arn
  
  tags = local.common_tags
}

# RDS Database
module "rds" {
  source = "./modules/rds_database"
  
  identifier                = var.identifier
  allocated_storage        = var.rds_allocated_storage
  instance_class           = var.rds_instance_class
  db_name                  = var.postgres_database
  username                 = var.postgres_username
  password                 = var.postgres_password
  
  private_subnet_ids       = aws_subnet.private[*].id
  vpc_security_group_ids   = [aws_security_group.rds.id]
  
  enabled_cloudwatch_logs_exports           = var.rds_enabled_cloudwatch_logs_exports
  performance_insights_enabled              = var.rds_performance_insights_enabled
  performance_insights_retention_period     = var.rds_performance_insights_retention_period
  monitoring_interval                       = var.rds_monitoring_interval
  
  log_retention_in_days = 30
  
  tags = local.common_tags
}


