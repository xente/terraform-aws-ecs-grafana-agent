output "ecs_agent_capacity_provider_name" {
  description = "Capacity provider to be added into ECS cluster"
  value       = aws_ecs_capacity_provider.this.name
}

output "ecs_agent_service_name" {
  description = "Grafana ECS services name"
  value       = aws_ecs_service.agent.name
}