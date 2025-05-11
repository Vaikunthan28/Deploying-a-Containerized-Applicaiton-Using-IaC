# 1. ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  tags = var.tags
}

# 2. Launch Template for EC2 instances in the cluster
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.cluster_name}-lt-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = var.instance_type

  iam_instance_profile {
    arn = var.instance_profile_arn
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

# 3. Auto Scaling Group (fixed size = vertical scaling only via instance_type)
resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "${var.cluster_name}-asg"
  max_size                  = var.max_capacity
  min_size                  = var.min_capacity
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.public_subnet_ids
  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }
  health_check_type         = "EC2"
  health_check_grace_period = 60
 
 dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# 4. ECS Capacity Provider connecting ASG
resource "aws_ecs_capacity_provider" "asg_cp" {
  name = "${var.cluster_name}-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "DISABLED"
    managed_scaling {
      status = "DISABLED"
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [aws_ecs_capacity_provider.asg_cp.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg_cp.name
    weight            = 1
  }
}

# 5. Task Definition (EC2 launch type)
resource "aws_ecs_task_definition" "app" {
  family                   = var.cluster_name
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.task_exec_role_arn

  container_definitions = jsonencode([
    {
      name      = var.cluster_name
      image     = "${var.repository_url}:latest"
      cpu       = var.task_cpu
      memory    = var.task_memory
      essential = true
      portMappings = [
        { containerPort = 80, hostPort = 80, protocol = "tcp" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.cluster_name}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.cluster_name
        }
      }
    }
  ])

  tags = var.tags
}

# 6. ECS Service
resource "aws_ecs_service" "app" {
  name            = var.cluster_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_capacity

  network_configuration {
    subnets          = var.public_subnet_ids    # your public subnet IDs
    security_groups  = [var.ecs_sg_id]          # SG allowing port 80
    assign_public_ip = true                     # give each task a public IP
  }
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg_cp.name
    weight            = 1
  }
  depends_on = [aws_ecs_cluster_capacity_providers.this]
}
# CloudWatch Log Group for ECS task logs
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = 7                # change as you like
  tags              = var.tags
}