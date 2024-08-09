variable "key_name" {
  description = "Key pair name for the EC2 instance"
  type        = string
}

variable "ami" {
  description = "The AMI ID for the Red Hat Linux image"
  type        = string
  default     = "ami-06640050dc3f556bb"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}
