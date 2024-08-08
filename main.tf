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
