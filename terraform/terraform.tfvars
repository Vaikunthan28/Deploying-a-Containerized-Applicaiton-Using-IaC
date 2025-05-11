aws_region     = "ap-southeast-2"
vpc_cidr       = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

common_tags = {Project = "platform-assignment"}
repository_name = "platform-starter"

cluster_name      = "cluster-1"
instance_type     = "t2.micro"
min_capacity      = 1
desired_capacity  = 1
max_capacity      = 1
task_cpu          = 256
task_memory       = 512
