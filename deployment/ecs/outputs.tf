output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.ecs.service_id
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = module.ecs.task_definition_arn
}

output "security_group_id" {
  description = "Security group ID for the ECS service"
  value       = module.ecs.security_group_id
}

output "log_group_name" {
  description = "CloudWatch log group for the application"
  value       = module.ecs.log_group_name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN for the application"
  value       = module.ecs.log_group_arn
}

output "ecs_cluster_name_friendly" {
  description = "Friendly name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name_friendly" {
  description = "Friendly name of the ECS service"
  value       = module.ecs.service_name
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "rds_instance_id" {
  description = "RDS instance ID"
  value       = module.rds.db_instance_id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.healthmetricsai_production_alb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.healthmetricsai_production_alb.zone_id
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.healthmetricsai_production_alb.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.ecs_tg.arn
}