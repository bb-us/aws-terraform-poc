# Terraform AWS Environment Setup

## Overview

This Terraform project sets up a basic AWS environment consisting of a VPC, subnets, EC2 instances, an Auto Scaling Group (ASG), an Application Load Balancer (ALB), and S3 buckets with lifecycle policies. The infrastructure is designed to demonstrate a proof of concept that can be extended or modified for specific use cases.

## Prerequisites

- **AWS Account:** You need to have an AWS account.
- **Terraform Installed:** Ensure that Terraform is installed on your machine. You can download it from [Terraform.io](https://www.terraform.io/downloads.html).
- **AWS CLI Installed:** Make sure that the AWS CLI is installed and configured with at least one profile. The AWS CLI is available [here](https://aws.amazon.com/cli/).
- **Configure AWS Credentials:** Your AWS credentials should be set up through the AWS CLI or by setting the environment variables (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).

## Directory Structure

```plaintext
.
├── main.tf             # Main Terraform configuration file with resource definitions.
├── asg.tf              # Auto Scaling Group configurations.
├── iam.tf              # IAM roles and policies configurations.
├── outputs.tf          # Output definitions for the Terraform configuration.
├── s3.tf               # S3 bucket configurations.
├── security-groups.tf  # Security group configurations.
├── user-data.sh        # User data script for EC2 instances.
└── variables.tf        # Variable definitions for Terraform configuration.
