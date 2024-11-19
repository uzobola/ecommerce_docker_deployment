# My EC2 outputs.tf


output "bastion_public_ips" {
  description = "Public IPs of bastion hosts"
  value = {
    az1 = aws_instance.bastion_az1.public_ip
    az2 = aws_instance.bastion_az2.public_ip
  }
}

output "app_private_ips" {
  description = "Private IPs of application instances"
  value = {
    az1 = aws_instance.app_az1.private_ip
    az2 = aws_instance.app_az2.private_ip
  }
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app.dns_name
}

output "app_sg_id" {
  description = "Security group ID for application servers"
  value       = aws_security_group.app.id
}


output "app_sg_id" {
  description = "Security group ID for application servers"
  value       = aws_security_group.app.id
}

output "bastion_sg_id" {
  description = "Security group ID for bastion hosts"
  value       = aws_security_group.bastion.id
}
