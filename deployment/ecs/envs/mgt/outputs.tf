output "twingate_service_sg_id" {
  description = "Security Group ID for the Twingate ECS service/tasks"
  value       = module.twingate_connector.service_sg_id
}
