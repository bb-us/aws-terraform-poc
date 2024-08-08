variable "vpc_name" {
  description = "Name of the VPC"
  default     = "poc-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.1.0.0/24", "10.1.1.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.1.2.0/24", "10.1.3.0/24"]
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ec2_ami" {
  description = "EC2 AMI ID"
  default     = "ami-xxxxxxxx" # Red Hat Linux AMI
}

variable "key_name" {
  description = "EC2 key pair name"
  default     = "poc-key"
}

variable "ec2_volume_size" {
  description = "EC2 root volume size"
  default     = 20
}

variable "asg_instance_type" {
  description = "ASG instance type"
  default     = "t2.micro"
}

variable "asg_min_size" {
  description = "ASG minimum size"
  default     = 2
}

variable "asg_max_size" {
  description = "ASG maximum size"
  default     = 6
}

variable "asg_desired_capacity" {
  description = "ASG desired capacity"
  default     = 2
}

variable "alb_name" {
  description = "ALB name"
  default     = "poc-alb"
}
