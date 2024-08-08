provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "git::https://github.com/Coalfire-CF/terraform-aws-vpc-nfw.git"
  name    = var.vpc_name
  cidr    = var.vpc_cidr
  azs     = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "ec2_instance" {
  source            = "git::https://github.com/Coalfire-CF/terraform-aws-ec2.git"
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

resource "aws_launch_template" "app_launch_template" {
  name_prefix          = "app-lt-${var.vpc_name}-"
  image_id             = var.ec2_ami
  instance_type        = var.asg_instance_type
  key_name             = var.key_name
  vpc_security_group_ids = [module.vpc.default_security_group_id]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.ec2_volume_size
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  vpc_zone_identifier = module.vpc.private_subnets

  tag {
    key                 = "Name"
    value               = "POC-ASG-Instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "app_alb" {
  name               = "app-alb-${var.vpc_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vpc.default_security_group_id]
  subnets            = module.vpc.public_subnets

  tags = {
    Name = "AppALB"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 443
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
