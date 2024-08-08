provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "git::https://github.com/Coalfire-CF/terraform-aws-vpc.git"
  name    = var.vpc_name
  cidr    = var.vpc_cidr
  azs     = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "ec2_instance" {
  source            = "git::https://github.com/Coalfire-CF/terraform-aws-ec2-instance.git"
  instance_type     = var.ec2_instance_type
  ami               = var.ec2_ami
  subnet_id         = module.vpc.public_subnets[1]
  key_name          = var.key_name
  root_block_device = {
    volume_size = var.ec2_volume_size
  }
  tags = {
    Name = "poc-ec2-instance"
  }
}

module "autoscaling" {
  source             = "git::https://github.com/Coalfire-CF/terraform-aws-autoscaling.git"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.private_subnets
  instance_type      = var.asg_instance_type
  min_size           = var.asg_min_size
  max_size           = var.asg_max_size
  desired_capacity   = var.asg_desired_capacity
  health_check_type  = "EC2"
  launch_template_id = aws_launch_template.app_launch_template.id
  tags = {
    Name = "poc-asg-instance"
  }
}

module "alb" {
  source  = "git::https://github.com/Coalfire-CF/terraform-aws-alb.git"
  name    = var.alb_name
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      default_action_type = "forward"
    }
  ]

  target_groups = [
    {
      name     = "poc-target-group"
      port     = 443
      protocol = "HTTP"
      vpc_id   = module.vpc.vpc_id
    }
  ]
}
