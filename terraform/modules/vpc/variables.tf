variable "aws_region" {
  type    = string
  default = "ap-southeast-2"   # Default AWS region
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"      # CIDR block for the VPC
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]  # Public subnet CIDRs
}

variable "tags" {
  description = "Tags to apply to all VPC resources"
  type        = map(string)
}