# CloudWatch Log Group for Twingate Connector
resource "aws_cloudwatch_log_group" "twingate_logs" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.enable_log_encryption ? var.log_kms_key_id : null

  tags = merge(var.tags, {
    Name    = "/ecs/${var.service_name}"
    Service = "TwingateConnector"
  })
}

# Twingate secret lookup by path (required)
data "aws_secretsmanager_secret" "twingate" {
  name = var.twingate_secret_path
}

# ECS Task Definition for Twingate Connector
resource "aws_ecs_task_definition" "twingate" {
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
      memory    = var.memory
      cpu       = var.cpu

      # readonlyRootFilesystem must be under linuxParameters
      linuxParameters = {
        readonlyRootFilesystem = var.readonly_root_filesystem
      },

      secrets = [
        { name = "TWINGATE_NETWORK",           valueFrom = "${data.aws_secretsmanager_secret.twingate.arn}:TWINGATE_NETWORK::" },
        { name = "TWINGATE_ACCESS_TOKEN",      valueFrom = "${data.aws_secretsmanager_secret.twingate.arn}:TWINGATE_ACCESS_TOKEN::" },
        { name = "TWINGATE_REFRESH_TOKEN",     valueFrom = "${data.aws_secretsmanager_secret.twingate.arn}:TWINGATE_REFRESH_TOKEN::" },
        { name = "TWINGATE_LABEL_DEPLOYED_BY", valueFrom = "${data.aws_secretsmanager_secret.twingate.arn}:TWINGATE_LABEL_DEPLOYED_BY::" }
      ],

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.twingate_logs.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "twingate-connector"
        }
      }
      # Twingate connector doesn't expose any ports
    }
  ])

  tags = var.tags
}

# Security Group for Twingate Connector
resource "aws_security_group" "twingate_connector" {
  name_prefix = "${var.service_name}-"
  vpc_id      = var.vpc_id
  description = "Security group for Twingate connector"

  # Twingate connector needs outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic for Twingate connectivity"
  }

  tags = merge(var.tags, {
    Name    = "${var.service_name}-sg"
    Service = "TwingateConnector"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# ECS Service for Twingate Connector
resource "aws_ecs_service" "twingate" {
  name             = var.service_name
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.twingate.arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  platform_version = var.platform_version
  enable_execute_command = var.twingate_exec

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.twingate_connector.id]
    assign_public_ip = var.assign_public_ip
  }

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  deployment_circuit_breaker {
    enable   = var.deployment_circuit_breaker_enabled
    rollback = var.deployment_circuit_breaker_rollback
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution_role_policy,
    aws_iam_role_policy_attachment.ecs_exec_attach_sm
  ]
}

# IAM Role for ECS Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.service_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      }
    ]
  })

  tags = var.tags
}

# IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.service_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      }
    ]
  })

  tags = var.tags
}

# Attach AWS managed policy for ECS execution
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

# Additional policy for ECS execution role to write to CloudWatch Logs
resource "aws_iam_role_policy" "ecs_execution_role_logs_policy" {
  name = "${var.service_name}-ecs-execution-logs-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = [
          aws_cloudwatch_log_group.twingate_logs.arn,
          "${aws_cloudwatch_log_group.twingate_logs.arn}:*"
        ]
      }
    ]
  })
}

# Allow the execution role to read the Twingate secret
data "aws_iam_policy_document" "ecs_exec_sm" {
  statement {
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = [
      data.aws_secretsmanager_secret.twingate.arn,
      "${data.aws_secretsmanager_secret.twingate.arn}*"
    ]
  }
}

resource "aws_iam_policy" "ecs_exec_sm" {
  name   = "${var.service_name}-ecs-exec-secretsmanager"
  policy = data.aws_iam_policy_document.ecs_exec_sm.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach_sm" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_exec_sm.arn
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
