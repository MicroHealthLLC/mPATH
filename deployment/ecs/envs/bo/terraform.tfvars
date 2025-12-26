aws_region            = "us-east-1"
environment           = "bo"
microsoft_secret_path = "mpath/bo/microsoft"

# --- RDS (cheap single-AZ) ---
db_identifier        = "mpath-bo-mysql"
db_name              = "mpath_prod"
db_username          = "mpath_admin"
db_password          = null
db_allocated_storage = 20
secret_name          = "mpath/bo/db"
kms_key_id           = null # or "arn:aws:kms:us-east-1:ACCOUNT:key/...."

# If your ECS tasks SG name is NOT "mpath-bo-ecs-tasks-sg", uncomment & set:
# ecs_tasks_sg_name = "your-ecs-tasks-sg-name"

# --- Container / service (unchanged) ---
container_image = "295669632222.dkr.ecr.us-east-1.amazonaws.com/microhealthllc/mpath-bo:latest"
desired_count   = 1
cpu             = 2048
memory          = 4096

# --- Healthcheck ---
health_check_path = "/users/sign_in"

ssl_policy              = "ELBSecurityPolicy-TLS13-1-2-2021-06"
alb_deletion_protection = true

# --- ECS deployment knobs ---
platform_version                    = "LATEST"
deployment_maximum_percent          = 200
deployment_minimum_healthy_percent  = 50
deployment_circuit_breaker_enabled  = true
deployment_circuit_breaker_rollback = true
log_retention_days                  = 30

waf_allowed_countries = ["US"]


tags = {
  App         = "mPATH"
  Env         = "bo"
  Owner       = "Microhealth Platform Engineering Team"
  CostCenter  = "Engineering"
  Application = "mpath"
}

db_secret_arn = aws_secretsmanager_secret.db.arn
mpath_exec = false
custom_domain_name = "mpath-ecs-bo.microhealthllc.com"
readonly_root_filesystem = false