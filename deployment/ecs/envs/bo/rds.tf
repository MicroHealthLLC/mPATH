# Password (only used if var.db_password == null)
resource "random_password" "db" {
  length           = 24
  special          = true
  override_special = "!@#%^*-_=+"
}

locals {
  db_password_final         = coalesce(var.db_password, random_password.db.result)
  derived_ecs_tasks_sg_name = coalesce(var.ecs_tasks_sg_name, "mpath-${local.env}-ecs-tasks-sg")
}

# DB Subnet Group (use private subnets from main.tf locals)
resource "aws_db_subnet_group" "this" {
  name       = "${var.db_identifier}-subnets"
  subnet_ids = local.private_subnet_ids
  tags       = merge(local.tags, { Name = "${var.db_identifier}-subnets" })
}

# Security Group for RDS – allow MySQL from ECS tasks only
resource "aws_security_group" "rds_mysql" {
  name        = "${var.db_identifier}-sg"
  description = "Allow MySQL from ECS tasks"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.ecs_service.service_sg_id,module.twingate_connector.service_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${var.db_identifier}-sg" })
}

# RDS Instance – MySQL 8, db.t3.micro, gp2, single-AZ
resource "aws_db_instance" "this" {
  identifier     = var.db_identifier
  engine         = "mysql"
  engine_version = "8.0" # safe major pin
  instance_class = "db.t3.micro"

  storage_type          = "gp2"
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = 100

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_mysql.id]
  port                   = 3306

  # Credentials
  username = var.db_username
  password = local.db_password_final
  db_name  = var.db_name

  # Availability & security
  multi_az            = false
  publicly_accessible = false
  storage_encrypted   = true

  # Backups & lifecycle
  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = false

  apply_immediately = true

  tags = merge(local.tags, { Name = var.db_identifier })
}

# Secrets Manager – JSON bundle for ECS injection
resource "aws_secretsmanager_secret" "db" {
  name        = var.secret_name
  description = "mPATH ${upper(local.env)} DB connection"
  kms_key_id  = var.kms_key_id
  tags        = merge(local.tags, { Name = var.secret_name })
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    adapter  = "mysql2"
    username = var.db_username
    password = local.db_password_final
    host     = aws_db_instance.this.address
    port     = 3306
    database = var.db_name
    url      = "mysql2://${var.db_username}:${local.db_password_final}@${aws_db_instance.this.address}:3306/${var.db_name}?encoding=utf8mb4&ssl_mode=required"
  })
}
