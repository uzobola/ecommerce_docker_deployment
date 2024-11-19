# My EC2 Module Variables


variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "dockerhub_username" {
  description = "DockerHub username"
  type        = string
}

variable "dockerhub_password" {
  description = "DockerHub password"
  type        = string
  sensitive   = true
}

variable "rds_endpoint" {
  description = "RDS endpoint"
  type        = string
}

variable "alb_health_check_path" {
  description = "Health check path for ALB"
  type        = string
  default     = "/"
}


