# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Toggle ALB creation inside this module
locals {
  do_alb = var.create_alb
}

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.container_insights_enabled ? "enabled" : "disabled"
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.service_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.service_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_execution_role_ecr_policy" {
  name = "${var.service_name}-ecs-execution-ecr-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port  # set to 8443 in env
          protocol      = "tcp"
        }
      ]

      environment = [
        for key, value in var.environment_variables : {
          name  = key
          value = value
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_logs.name,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = "ecs"
        }
      }

      healthCheck = var.health_check_enabled ? {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}${var.health_check_path} || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      } : null
    }
  ])

  tags = var.tags
}


resource "aws_security_group" "ecs_service" {
  name_prefix = "${var.service_name}-ecs-"
  vpc_id      = var.vpc_id
  description = "Security group for ${var.service_name} ECS service"

  # Allow from any explicitly provided source SGs (e.g., ALB SG)
  dynamic "ingress" {
    for_each = var.allowed_source_sg_ids
    content {
      from_port       = var.container_port
      to_port         = var.container_port
      protocol        = "tcp"
      security_groups = [ingress.value]
      description     = "Allowed SG -> ECS container port"
    }
  }

  # If the ALB is created in this module, also allow from that ALB SG
  dynamic "ingress" {
    for_each = local.do_alb ? [aws_security_group.alb[0].id] : []
    content {
      from_port       = var.container_port
      to_port         = var.container_port
      protocol        = "tcp"
      security_groups = [ingress.value]
      description     = "Module ALB SG -> ECS container port"
    }
  }

  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.service_name}-ecs-sg" })

  lifecycle { create_before_destroy = true }
}


# ALB SG
resource "aws_security_group" "alb" {
  count       = local.do_alb ? 1 : 0
  name_prefix = "${var.service_name}-alb-"
  vpc_id      = var.vpc_id
  description = "ALB SG for ${var.service_name}"

  ingress { from_port = 80  to_port = 80  protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  egress  { from_port = 0   to_port = 0   protocol = "-1"  cidr_blocks = ["0.0.0.0/0"] }

  tags = merge(var.tags, { Name = "${var.service_name}-alb-sg" })
}

# ALB
resource "aws_lb" "this" {
  count                     = local.do_alb ? 1 : 0
  name                      = coalesce(var.alb_name, "${var.service_name}-alb")
  internal                  = false
  load_balancer_type        = "application"
  security_groups           = local.do_alb ? [aws_security_group.alb[0].id] : null
  subnets                   = local.do_alb ? var.public_subnet_ids : null
  enable_deletion_protection = var.alb_deletion_protection
  tags                      = var.tags
}

# Target Group (ALB -> ECS tasks)
# Note: default to HTTP to the container on var.container_port (8443).
# If your app speaks TLS on 8443, change protocol to "HTTPS" and add a cert on the task or use TLS termination differently.
resource "aws_lb_target_group" "ecs" {
  count       = local.do_alb ? 1 : 0
  name        = "${var.service_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = var.health_check_path
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = var.tags
}

# HTTPS listener (443) with TLS termination
resource "aws_lb_listener" "https" {
  count             = local.do_alb ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs[0].arn
  }

  tags = var.tags
}

# HTTP -> HTTPS redirect
resource "aws_lb_listener" "http" {
  count             = local.do_alb ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = var.tags
}


locals {
  effective_tg_arn = var.target_group_arn != null ? var.target_group_arn :
    (local.do_alb ? aws_lb_target_group.ecs[0].arn : null)
}

resource "aws_ecs_service" "app" {
  name             = var.service_name
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  platform_version = var.platform_version

  network_configuration {
    subnets          = var.subnet_ids          # private subnets
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = var.assign_public_ip
  }

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  deployment_circuit_breaker {
    enable   = var.deployment_circuit_breaker_enabled
    rollback = var.deployment_circuit_breaker_rollback
  }

  # Attach to TG if provided/created
  dynamic "load_balancer" {
    for_each = local.effective_tg_arn != null ? [1] : []
    content {
      target_group_arn = local.effective_tg_arn
      container_name   = var.service_name
      container_port   = var.container_port
    }
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution_role_policy
  ]
}
