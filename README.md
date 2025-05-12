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

<img width="1430" alt="image" src="https://github.com/user-attachments/assets/02979283-5592-4ddd-97dd-aad9544c5a02" />


### Pending Issues
SNS → GitLab subscription confirmation: direct HTTPS remains in PendingConfirmation.

Steps:

1. Ran the Application locally:

Wrote a simple Dockerfile based on nginx:1.24-alpine that removed the default content, copied my simple HTML file (in the folder /WebApp), added a basic health check, configured log forwarding, and exposed it to port 80. Built and ran the container locally on Docker Hub (docker build, docker run) to verify that my static site runs correctly.
<img width="1240" alt="image" src="https://github.com/user-attachments/assets/f7d35262-956c-41c0-8270-de8ba4212e49" />
<img width="794" alt="image" src="https://github.com/user-attachments/assets/87f5bc8a-46cb-44ca-86f8-df53cbf96d70" />


2. Created AWS Free Tier Account

Logged into my AWS account and created an IAM user with admin access. Created an S3 bucket (terraform-state-vaikunthan) and a DynamoDB table (terraform-locks) for Terraform state and locking.

![image](https://github.com/user-attachments/assets/f36bad5b-dbf0-4451-95fd-13af84c70a6e)

![image](https://github.com/user-attachments/assets/558a25f3-edfc-4e01-98dc-8ac057cf2984)

![image](https://github.com/user-attachments/assets/2567270b-8f6c-48dd-90d1-44c20c6befd9)

3. Terraform Modules

Next, I structured the Terraform code into modular components: a VPC module to provide a networking foundation, an IAM module to grant ECS tasks and EC2 instances the correct permissions, an ECR module to host the container image, and an ECS module that deployed a cluster on EC2 with an Auto Scaling Group, Launch Template, task definition (including awslogs logging), and service definition in bridge mode. I wired all these modules together in the root configuration and tested end to end by running terraform apply, which provisioned my VPC, ECS cluster, ECR repository, and associated resources.

![image](https://github.com/user-attachments/assets/a8b10bd5-2ba3-4ebc-b003-d42e66077622)
![image](https://github.com/user-attachments/assets/b65fcede-b800-44aa-ab6c-5febcd678b17)
![image](https://github.com/user-attachments/assets/865dbf98-442b-465f-b1ea-ce55e6edaf4e)
![image](https://github.com/user-attachments/assets/f08e3a06-ae92-466e-858a-b0b058157624)
![image](https://github.com/user-attachments/assets/1fc450f6-f035-41be-9fc4-1b88839c1fd0)
![image](https://github.com/user-attachments/assets/2ed878f1-d51b-4d3d-9821-9fa4577b902c)


4. GitLab CICD

With infrastructure in place, I turned to automation. I created a .gitlab-ci.yml pipeline that validated and planned Terraform changes on each push, built and pushed Docker images to ECR, updated the ECS task definition, and deployed the new image to the running service. Manual approval gates on the apply and destroy stages ensured I would not inadvertently modify or tear down resources without confirmation.

![image](https://github.com/user-attachments/assets/9b12d4ec-3837-49c5-9cb7-050b10567229)
![image](https://github.com/user-attachments/assets/d35c4e5e-59d6-4e41-b146-51d8bd84b564)
![image](https://github.com/user-attachments/assets/ca1a2e82-cce0-47cd-b4e1-3f358950073f)

5. Vertical Scaling

To support vertical scaling, I added a dedicated scale job in the same pipeline that only executes when triggered via the GitLab pipeline trigger webhook. This job applies a Terraform change to update the EC2 instance type in the Launch Template and then starts an ASG instance refresh to roll in the new size with manual instance termination. I confirmed this workflow by overriding the NEW_INSTANCE_TYPE variable in GitLab, observing Terraform update the launch template, and watching the ASG automatically replace the old t2.micro instances with t3.small ones.

### Undone job: Here I keep trying to scale the instance type without terminating the current instance. after the scale job is completed, it affects only in ASG. I have to manually terminate the instance to take effect.

![image](https://github.com/user-attachments/assets/8c88fb66-0fbb-491b-84a2-778ea745b255)

![image.png](attachment:08db5a70-268a-4698-9b59-89494e005a9a:image.png)
![image.png](attachment:4ac2f2bb-b0df-42bd-8b96-e479085bbb1f:image.png)



   






