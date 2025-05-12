module "vpc" {
  source         = "./modules/vpc"
  aws_region     = var.aws_region
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  tags           = var.common_tags
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.repository_name
  tags            = var.common_tags
}

module "iam" {
  source = "./modules/iam"
  tags   = var.common_tags
}

module "ecs" {
  source             = "./modules/ecs"
  aws_region         = var.aws_region
  cluster_name       = var.cluster_name
  instance_type      = var.instance_type
  desired_capacity   = var.desired_capacity
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  public_subnet_ids  = module.vpc.public_subnet_ids
  ecs_sg_id          = module.vpc.ecs_sg_id
  instance_profile_arn = module.iam.instance_profile_arn
  task_exec_role_arn = module.iam.task_exec_role_arn
  repository_url     = module.ecr.repository_url
  task_cpu           = var.task_cpu
  task_memory        = var.task_memory
  tags               = var.common_tags
}
module "monitoring" {
  source      = "./modules/monitoring"
  cluster_name = module.ecs.cluster_name    # "cluster-1"
  asg_name     = module.ecs.asg_name        # ASG name output
  trigger_url  = var.GITLAB_TRIGGER_URL     # from CI/CD variables
}
