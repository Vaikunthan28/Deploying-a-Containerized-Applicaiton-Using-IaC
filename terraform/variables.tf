variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = { Project = "platform-assignment" }
}

variable "repository_name" {
  description = "Name for the ECR repository"
  type        = string
  default     = "platform-starter"
}

variable "GITLAB_TRIGGER_URL" {
  description = "GitLab pipeline trigger webhook URL"
  type        = string
}

variable "cluster_name"      { default = "cluster-1" }
variable "instance_type"     { default = "t2.micro" }
variable "min_capacity"      { default = 1 }
variable "desired_capacity"  { default = 1 }
variable "max_capacity"      { default = 1 }
variable "task_cpu"          { default = 256 }
variable "task_memory"       { default = 512 }
