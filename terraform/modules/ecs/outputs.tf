output "cluster_id" {
  value = aws_ecs_cluster.this.id
}
output "autoscaling_group_id" {
  value = aws_autoscaling_group.ecs_asg.id
}
output "task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
}
# Export the ECS cluster name
output "cluster_name" {
  description = "Name of the ECS Cluster"
  value       = aws_ecs_cluster.this.name
}

# Export the Auto Scaling Group name
output "asg_name" {
  description = "Name of the EC2 Auto Scaling Group backing the ECS cluster"
  value       = aws_autoscaling_group.ecs_asg.name
}