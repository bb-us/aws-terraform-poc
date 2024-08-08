resource "aws_launch_template" "app_launch_template" {
  name          = "app-launch-template"
  image_id      = var.ec2_ami
  instance_type = var.asg_instance_type
  user_data     = filebase64("${path.module}/user-data.sh")

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.ec2_volume_size
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
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
