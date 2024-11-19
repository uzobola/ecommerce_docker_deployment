# my root outputs.tf

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "bastion_public_ips" {
  description = "Public IPs of bastion hosts"
  value       = module.ec2.bastion_public_ips
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.endpoint
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.ec2.alb_dns_name
}

