# Configure Terraform to use an S3 bucket for state storage and DynamoDB table for state locking to prevent concurrent writes

terraform {
  backend "s3" {
    bucket         = "terraform-state-vaikunthan"  # S3 bucket
    key            = "network/terraform.tfstate"  # Path in bucket
    region         = "ap-southeast-2"             # AWS region for bucket
    dynamodb_table = "terraform-locks"           # DynamoDB table for locks
    encrypt        = true                          # Enable SSE encryption
  }
}