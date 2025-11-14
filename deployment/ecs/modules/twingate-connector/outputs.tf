output "task_definition_arn" {
  description = "ARN of the Twingate connector task definition"
  value       = aws_ecs_task_definition.twingate.arn
}

output "service_arn" {
  description = "ARN of the Twingate connector service"
  value       = aws_ecs_service.twingate.id
}

output "service_name" {
  description = "Name of the Twingate connector service"
  value       = aws_ecs_service.twingate.name
}

output "security_group_id" {
  description = "ID of the Twingate connector security group"
  value       = aws_security_group.twingate_connector.id
}

output "execution_role_arn" {
  description = "ARN of the Twingate connector execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "task_role_arn" {
  description = "ARN of the Twingate connector task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "service_sg_id" {
  description = "Security Group ID attached to the ECS service/tasks"
  value       = aws_security_group.twingate_connector.id
}