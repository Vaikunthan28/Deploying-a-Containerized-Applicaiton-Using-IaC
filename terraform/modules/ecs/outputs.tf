output "cluster_id" {
  value = aws_ecs_cluster.this.id
}
output "autoscaling_group_id" {
  value = aws_autoscaling_group.ecs_asg.id
}
output "task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
}
