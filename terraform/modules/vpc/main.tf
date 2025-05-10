# Create a VPC with DNS support and hostnames
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "vpc-${var.tags.Project}" })
}

# Create an Internet Gateway attached to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = merge(var.tags, { Name = "igw-${var.tags.Project}" })
}

# Create public subnets and enable public IP assignment
resource "aws_subnet" "public" {
  for_each                = toset(var.public_subnets)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "subnet-public-${each.value}" })
}

# Create route table for public subnets and a default route to IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "rtb-public-${var.tags.Project}" })
}

# Associate each public subnet with the public route table
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Create a Network ACL for the public subnets
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.my_vpc.id
  subnet_ids = [for s in aws_subnet.public : s.id]
  tags       = merge(var.tags, { Name = "nacl-public-${var.tags.Project}" })
}

# Allow inbound HTTP on port 80
resource "aws_network_acl_rule" "allow_http_in" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "6"              # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Allow outbound ephemeral ports for return traffic
resource "aws_network_acl_rule" "allow_ephemeral_out" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = true
  protocol       = "6"              # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Security Group for ECS tasks: allow HTTP inbound and all outbound traffic
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg-${var.tags.Project}"
  description = "Allow HTTP inbound and all outbound"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound
  }

  tags = merge(var.tags, { Name = "sg-ecs-${var.tags.Project}" })
}