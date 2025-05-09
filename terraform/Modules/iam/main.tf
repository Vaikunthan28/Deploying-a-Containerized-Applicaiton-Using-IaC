# Create IAM roles and attach policies for ECS

data "aws_iam_policy_document" "ecs_instance_assume" {
  statement {
    actions    = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance" {
  name               = "ecsInstanceRole-${var.tags.Project}"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_instance_attach" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = aws_iam_role.ecs_instance.name   # e.g. ecsInstanceRole-platform-assignment
  role = aws_iam_role.ecs_instance.name
  tags = var.tags
}
data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions    = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_exec" {
  name               = "ecsTaskExecutionRole-${var.tags.Project}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_attach" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}