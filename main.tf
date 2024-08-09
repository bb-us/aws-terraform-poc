provider "aws" {
  region = "us-east-1"
}

# EC2 Instance in Public Subnet 2
resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 20
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "example-web"
  }
}

# Launch Configuration for Auto Scaling Group
resource "aws_launch_configuration" "app" {
  name          = "app-launch-configuration"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  root_block_device {
    volume_size = 20
  }

  iam_instance_profile = aws_iam_instance_profile.asg_profile.name

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.name
  min_size             = 2
  max_size             = 6
  vpc_zone_identifier  = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  force_delete = true
}
