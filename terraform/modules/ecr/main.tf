# Create an ECR repository to store Docker images
resource "aws_ecr_repository" "repo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
  tags                 = var.tags
}