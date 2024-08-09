
---

# AWS Proof-of-Concept Environment using Terraform

This repository contains Terraform configurations to deploy a proof-of-concept (PoC) environment in AWS. The infrastructure includes a VPC, subnets, EC2 instances, an Auto Scaling Group, an Application Load Balancer (ALB), IAM roles, and associated security configurations.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Pre-requisites](#pre-requisites)
- [Usage](#usage)
- [Configuration](#configuration)
- [Variables](#variables)
- [Outputs](#outputs)
- [Resources](#resources)
- [License](#license)

## Architecture Overview

This Terraform configuration sets up the following architecture:
- **VPC:** A Virtual Private Cloud with CIDR block `10.1.0.0/16`.
- **Subnets:** 
  - Two public subnets (`10.1.0.0/24` and `10.1.1.0/24`) across two availability zones.
  - Two private subnets (`10.1.2.0/24` and `10.1.3.0/24`) across the same availability zones.
- **Internet Gateway:** Allows internet access to resources in public subnets.
- **Security Groups:** Manages inbound and outbound traffic for EC2 instances.
- **EC2 Instance:** A web server running Red Hat Linux, hosted in one of the public subnets.
- **Auto Scaling Group:** Automatically scales EC2 instances across private subnets.
- **Application Load Balancer (ALB):** Distributes incoming HTTP traffic across instances in the Auto Scaling Group.
- **IAM Roles & Policies:** Ensures proper permissions for Auto Scaling Group and logging.

## Pre-requisites

Before you begin, ensure you have the following:
- **AWS Account:** An active AWS account.
- **Terraform:** Terraform version 0.12 or later.
- **AWS CLI:** Installed and configured with your AWS credentials.
- **SSH Key Pair:** A key pair created in the AWS region where you will deploy this infrastructure.

## Usage

### Clone the Repository
```bash
git clone <repository-url>
cd <repository-directory>
```

### Initialize Terraform
Initialize the Terraform environment by downloading the necessary providers.
```bash
terraform init
```

### Plan the Deployment
Review the changes that Terraform will make to your AWS environment.
```bash
terraform plan
```

### Apply the Configuration
Deploy the infrastructure to your AWS environment.
```bash
terraform apply
```

### Destroy the Infrastructure
When you no longer need the environment, you can destroy it to avoid incurring costs.
```bash
terraform destroy
```

## Configuration

### SSH Key Pair
Ensure that the SSH key pair name specified in the `key_name` variable exists in your AWS account and region. If not, create a new key pair through the AWS Management Console or AWS CLI.

### Customizing the Configuration
You can customize the configuration by modifying the `variables.tf` file or passing variables through the command line or a `.tfvars` file.

## Variables

| Variable Name | Description | Default Value |
|---------------|-------------|---------------|
| `key_name`    | Name of the AWS SSH key pair to use for EC2 instances | N/A (Required) |
| `instance_type` | The EC2 instance type for the web server and ASG | `t2.micro` |
| `ami` | The AMI ID for the Red Hat Linux image | `ami-06640050dc3f556bb` |

## Outputs

| Output Name | Description |
|-------------|-------------|
| `instance_public_ip` | The public IP address of the EC2 instance |
| `alb_dns_name` | The DNS name of the Application Load Balancer |

## Resources

This Terraform configuration will create the following AWS resources:
- 1 VPC
- 4 Subnets (2 public, 2 private)
- 1 Internet Gateway
- 1 Route Table (for public subnets)
- 1 Security Group (for EC2 instances)
- 1 EC2 Instance (running a web server)
- 1 Launch Configuration (for Auto Scaling Group)
- 1 Auto Scaling Group
- 1 Application Load Balancer (ALB)
- 1 Target Group (for the ALB)
- 2 IAM Roles and associated policies (for ASG and logging)

---

This README provides an overview of the project, detailed instructions for deployment, and information on how to customize and manage the infrastructure.
