output "rds_endpoint" {
  description = "Full RDS endpoint (hostname:port)."
  value       = aws_db_instance.this.endpoint
}

output "rds_sg_id" {
  description = "Security Group ID attached to the RDS instance."
  value       = aws_security_group.rds_mysql.id
}

output "rds_db_name" {
  description = "Name of the database created."
  value       = var.db_name
}

output "db_secret_arn" {
  description = "Secrets Manager secret ARN with DB credentials."
  value       = aws_secretsmanager_secret.db.arn
}

output "qa_alb_dns_name" {
  value = module.ecs_service.alb_dns_name
}

output "qa_target_group_arn" {
  value = module.ecs_service.target_group_arn_effective
}

output "qa_ecs_service_sg" {
  value = module.ecs_service.security_group_id
}