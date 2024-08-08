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
