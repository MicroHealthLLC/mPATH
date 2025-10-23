output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.app.id
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/${aws_ecs_cluster.main.name}/${aws_ecs_service.app.name}"
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.app.arn
}

output "security_group_id" {
  description = "ECS tasks security group ID"
  value       = aws_security_group.ecs_service.id
}

output "execution_role_arn" {
  description = "ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app_logs.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app_logs.arn
}


output "alb_security_group_id" {
  description = "ALB security group ID (null if ALB not created in-module)"
  value       = try(aws_security_group.alb[0].id, null)
}

output "alb_arn" {
  description = "ALB ARN (null if ALB not created in-module)"
  value       = try(aws_lb.this[0].arn, null)
}

output "alb_dns_name" {
  description = "ALB DNS name (null if ALB not created in-module)"
  value       = try(aws_lb.this[0].dns_name, null)
}

output "alb_zone_id" {
  description = "Route53 zone ID for ALB alias (null if ALB not created in-module)"
  value       = try(aws_lb.this[0].zone_id, null)
}

output "target_group_arn_created" {
  description = "ARN of the TG created by the module (null if not created)"
  value       = try(aws_lb_target_group.ecs[0].arn, null)
}

# Effective TG used by the service (created or provided via var.target_group_arn)
output "target_group_arn_effective" {
  description = "Target Group ARN actually used by the ECS service"
  value       = local.effective_tg_arn
}

output "service_sg_id" {
  description = "Security Group ID attached to the ECS service/tasks"
  value       = aws_security_group.ecs_service.id
}
