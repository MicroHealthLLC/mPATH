# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Microsoft OAuth secret lookup by path
data "aws_secretsmanager_secret" "microsoft" {
  count = var.microsoft_secret_path != null && var.microsoft_secret_path != "" ? 1 : 0
  name  = var.microsoft_secret_path
}

# Toggle ALB creation inside this module
locals {
  do_alb = var.create_alb

  # Use explicit ALB name if provided; else default to "<service_name>-alb"
  alb_name_effective = coalesce(var.alb_name, "${var.service_name}-alb")
}

locals {
  microsoft_secret_arn = length(data.aws_secretsmanager_secret.microsoft) > 0 ? data.aws_secretsmanager_secret.microsoft[0].arn : null
}

# Secrets to inject into the container (built from the ARNs passed in)
locals {
  container_secrets = concat(
    var.db_secret_arn != null ? [
      { name = "DB_USERNAME", valueFrom = "${var.db_secret_arn}:username::" },
      { name = "DB_PASSWORD", valueFrom = "${var.db_secret_arn}:password::" },
      { name = "DB_HOST", valueFrom = "${var.db_secret_arn}:host::" },
      { name = "DB_PORT", valueFrom = "${var.db_secret_arn}:port::" },
      { name = "DB_NAME", valueFrom = "${var.db_secret_arn}:database::" },
      { name = "DB_ADAPTER", valueFrom = "${var.db_secret_arn}:adapter::" },
      { name = "DATABASE_URL", valueFrom = "${var.db_secret_arn}:url::" }
    ] : [],
    var.app_secret_arn != null ? [
      # Rails core
      { name = "SECRET_KEY_BASE", valueFrom = "${var.app_secret_arn}:SECRET_KEY_BASE::" }
      # { name = "OFFICE365_CLIENT_ID", valueFrom = "${var.app_secret_arn}:OFFICE365_CLIENT_ID::" } # (kept commented from original)
    ] : [],
    local.microsoft_secret_arn != null ? [
      { name = "OFFICE365_CLIENT_ID", valueFrom = "${local.microsoft_secret_arn}:OFFICE365_CLIENT_ID::" },
      { name = "OFFICE365_CLIENT_SECRET", valueFrom = "${local.microsoft_secret_arn}:OFFICE365_CLIENT_SECRET::" },
      { name = "OFFICE365_REDIRECT_URI", valueFrom = "${local.microsoft_secret_arn}:OFFICE365_REDIRECT_URI::" },
      { name = "OFFICE365_PROVIDER_URL", valueFrom = "${local.microsoft_secret_arn}:OFFICE365_PROVIDER_URL::" }
    ] : []
  )
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
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
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
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = var.tags
}

# AWS-managed policy for pulling from ECR, writing logs, etc.
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# Attach SSM Managed Instance Core to allow ECS Exec sessions
resource "aws_iam_role_policy_attachment" "ecs_execution_role_ssm" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach CloudWatch Agent Server policy (optional but useful for ECS Exec sessions)
resource "aws_iam_role_policy_attachment" "ecs_execution_role_cwagent" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach the same to the ECS task role (so the container itself can establish session)
resource "aws_iam_role_policy_attachment" "ecs_task_role_ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Extra ECR actions (kept from your original)
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

# ---- ECS Task Definition (inject secrets) ----
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
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        for key, value in var.environment_variables : {
          name  = key
          value = value
        }
      ]

      linuxParameters = {
        readonlyRootFilesystem = var.readonly_root_filesystem
      }
      # Secrets injected by ECS at container start
      secrets = local.container_secrets

      # Run Rails seeds after short delay, then start the app
      command = [
        "bash", "-lc",
        "sleep 10 && echo 'Running Rails seeds...' && bundle exec rails db:seed RAILS_ENV=production || true; echo 'Starting Puma...' && bundle exec puma -C config/puma.rb"
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_logs.name,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = "ecs"
        }
      },

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

# ---- Networking SGs ----
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
      description     = "Allowed SG  to  ECS container port"
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
      description     = "Module ALB SG  to  ECS container port"
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

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.service_name}-alb-sg" })
}

# ALB
resource "aws_lb" "this" {
  count                      = local.do_alb ? 1 : 0
  name                       = local.alb_name_effective
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = local.do_alb ? [aws_security_group.alb[0].id] : null
  subnets                    = local.do_alb ? var.public_subnet_ids : null
  enable_deletion_protection = var.alb_deletion_protection
  tags                       = var.tags
}

# Target Group
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

# HTTPS listener (443)
resource "aws_lb_listener" "https" {
  count             = local.do_alb ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn

  # DEFAULT: Redirect EVERY request unless a rule overrides it
  default_action {
    type = "redirect"

    redirect {
      host        = var.custom_domain_name
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

# Rule 1: Allow only the custom domain → forward to ECS
resource "aws_lb_listener_rule" "allow_only_custom_domain" {
  count        = local.do_alb ? 1 : 0
  listener_arn = aws_lb_listener.https[0].arn
  priority     = 1

  condition {
    host_header {
      values = [var.custom_domain_name]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs[0].arn
  }
}

# Rule 2: Redirect ALB DNS → clean redirect
resource "aws_lb_listener_rule" "redirect_alb_dns_to_custom_domain" {
  count        = local.do_alb ? 1 : 0
  listener_arn = aws_lb_listener.https[0].arn
  priority     = 2

  condition {
    host_header {
      values = [
        aws_lb.this[0].dns_name
      ]
    }
  }

  action {
    type = "redirect"
    redirect {
      host        = var.custom_domain_name
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

locals {
  effective_tg_arn = var.target_group_arn != null ? var.target_group_arn : (local.do_alb ? aws_lb_target_group.ecs[0].arn : null)
}

resource "aws_ecs_service" "app" {
  name             = var.service_name
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  platform_version = var.platform_version
  enable_execute_command = var.mpath_exec

  network_configuration {
    subnets          = var.subnet_ids # private subnets
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = var.assign_public_ip
  }

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  deployment_circuit_breaker {
    enable   = var.deployment_circuit_breaker_enabled
    rollback = var.deployment_circuit_breaker_rollback
  }

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

# ---- Allow the ECS *execution role* to read Secrets Manager (and KMS if needed) ----
locals {
  secret_arns   = compact([var.db_secret_arn, var.app_secret_arn, local.microsoft_secret_arn])
  kms_key_arns_ = var.kms_key_arns # optional list; pass only if you used CMKs on the secrets
}

resource "aws_iam_role_policy" "ecs_exec_secrets" {
  
  name  = "${var.service_name}-exec-secrets"
  role  = aws_iam_role.ecs_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      [
        {
          Sid    = "ReadSecretsFromSecretsManager"
          Effect = "Allow"
          Action = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ]
          Resource = local.secret_arns
        }
      ],
      length(local.kms_key_arns_) > 0 ? [
        {
          Sid      = "DecryptSecretsWithKMS"
          Effect   = "Allow"
          Action   = ["kms:Decrypt"]
          Resource = local.kms_key_arns_
        }
      ] : []
    )
  })
}
