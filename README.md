
# Deploying a Containerized Application Using IaC

### Introduction

**Brief description of this project's objectives:**

- Build a simple static-site container (Nginx) and deploy to AWS ECS on EC2 with Terraform
- Automate infrastructure provisioning via GitLab CI/CD
- Support manual vertical scaling via pipeline-triggered Terraform changes

### Status:
- ✅ Local prototype & Terraform infra + CI/CD build/deploy ✅
- ⚠️ Vertical scaling available manually via scale job; automatic SNS→GitLab trigger is pending.
- 📋 CloudWatch Logs enabled for ECS Task definitions.

### Project Structure & Files

### Project Structure & Files

```
├─ terraform/                   # All Terraform configs
│  ├─ modules/
│  │  ├─ vpc/                   # VPC, subnets, SG, NACL
│  │  ├─ ecs/                   # ECS cluster, ASG, LT, TaskDef, Service, CloudWatch Logs
│  │  ├─ ecr/                   # ECR repository
│  │  └─ monitoring/            # SNS & CloudWatch alarm
│  ├─ main.tf                   # Root module calls all modules
│  ├─ variables.tf              # Root input definitions
│  ├─ terraform.tfvars          # Variable values (backend, trigger URL)
│  └─ backend.tf                # S3 / DynamoDB backend config
│
└─ .gitlab-ci.yml               # GitLab CI/CD pipeline
```


### Architecture Overview
Components:

- VPC (public subnets, IGW, route table, NACL, SG)  
- ECS cluster on EC2 (ASG + capacity provider)  
- ECR for container images  
- CloudWatch Alarm → SNS → GitLab trigger (manual scale)  
- GitLab pipeline for infra- & application deployment

<img width="1430" alt="image" src="https://github.com/user-attachments/assets/02979283-5592-4ddd-97dd-aad9544c5a02" />

   






