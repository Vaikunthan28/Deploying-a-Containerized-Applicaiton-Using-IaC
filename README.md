# 1. Comparing DevOps vs. Platform Engineering

DevOps combines development and operations to automate building, testing, and deploying code quickly and reliably, using CI/CD pipelines and monitoring to catch issues early. Platform Engineering builds on this by offering a self-service layer with preconfigured modules, templates, and tools that let teams provision infrastructure with a single command. While DevOps focuses on fast, collaborative delivery, Platform Engineering scales that speed across the organization by providing a consistent, secure foundation. Together, they enable rapid, reliable releases without reinventing the wheel.
# 2. The Trend Toward DevSecOps and Why It Matters

DevSecOps means adding security checks into every step of building and deploying software, instead of leaving it until the end. As code moves through the pipeline, tools automatically scan for vulnerabilities, enforce security rules, and block anything risky. This way, teams catch problems early and avoid last-minute panic or expensive fixes. When developers, operations, and security all work together, every release is fast and safe. In today’s world of constant cyber threats, weaving security into our daily workflow is the best way to stay ahead without slowing down.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Platform Assignment

### Introduction

**Brief description of the assignment objectives:**

- Build a simple static-site container (Nginx) and deploy to AWS ECS on EC2 with Terraform
- Automate infrastructure provisioning via GitLab CI/CD
- Support manual vertical scaling via pipeline-triggered Terraform changes

### Status:
- ✅ Local prototype & Terraform infra + CI/CD build/deploy ✅
- ⚠️ Vertical scaling available manually via scale job; automatic SNS→GitLab trigger pending.
- 📋 CloudWatch Logs enabled for ECS Task definitions.

### Project Structure & Files

```
terraform/
├── modules/
│   ├── vpc/                   # VPC, subnets, SG, NACL
│   ├── ecs/                   # ECS cluster, ASG, launch template, task def, service
│   ├── ecr/                   # ECR repository
│   └── monitoring/            # CloudWatch alarms & SNS
├── main.tf                   # Root module calls all modules
├── variables.tf              # Root input definitions
├── terraform.tfvars          # Variable values (backend, trigger URL)
└── backend.tf                # S3/DynamoDB backend config

.gitlab-ci.yml               # GitLab CI/CD pipeline
```


### Architecture Overview
Components:

- VPC (public subnets, IGW, route table, NACL, SG)  
- ECS cluster on EC2 (ASG + capacity provider)  
- ECR for container images  
- CloudWatch Alarm → SNS → GitLab trigger (manual scale)  
- GitLab pipeline for infra- & application deployment

![image](https://github.com/user-attachments/assets/a8e15dd2-2193-4064-b104-ed2f5fd75a8b)

### Pending Issues
SNS → GitLab subscription confirmation: direct HTTPS remains in PendingConfirmation.

Steps:
