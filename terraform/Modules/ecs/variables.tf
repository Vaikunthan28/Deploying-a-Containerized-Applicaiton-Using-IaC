variable "aws_region" {
  description = "AWS region for cluster and logs"
  type        = string
}
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type for the cluster"
  type        = string
}
variable "desired_capacity" {
  description = "Number of EC2 instances to run"
  type        = number
}
variable "min_capacity" {
  description = "Minimum size of the ASG"
  type        = number
}
variable "max_capacity" {
  description = "Maximum size of the ASG"
  type        = number
}
variable "public_subnet_ids" {
  description = "List of subnet IDs for EC2 instances"
  type        = list(string)
}
variable "ecs_sg_id" {
  description = "Security Group ID for ECS tasks"
  type        = string
}
variable "instance_profile_arn" {
  description = "ARN of the IAM role for EC2 instances"
  type        = string
}
variable "task_exec_role_arn" {
  description = "ARN of the IAM role for ECS task execution"
  type        = string
}
variable "repository_url" {
  description = "ECR repository URL for the container image"
  type        = string
}
variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
}
variable "task_memory" {
  description = "Memory (MB) for the task"
  type        = number
}
variable "tags" {
  description = "Tags to apply to all ECS resources"
  type        = map(string)
}
