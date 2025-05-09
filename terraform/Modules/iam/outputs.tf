# Outputs from the IAM module

output "instance_role_arn" {
  description = "ARN of the ECS instance role"
  value       = aws_iam_role.ecs_instance.arn
}

output "task_exec_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_exec.arn
}
output "instance_profile_arn" {
  description = "ARN of the EC2 instance profile for ECS nodes"
  value       = aws_iam_instance_profile.ecs_instance_profile.arn
}
