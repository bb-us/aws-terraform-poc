output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
