# EC2 Main.tf

##This file contains my
#- EC2 instances
#- Security Groups
#- Application Load balancer


# Security Groups: Bastion Hosts
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Security group for bastion hosts"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}


# Security Groups: App Servers
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Security group for application servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}


#Security Groups: Load balancer
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}


# EC2: Bastion Host in AZ1
resource "aws_instance" "bastion_az1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnets[0]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "bastion_az1"
  }
}

# EC2: Bastion Host in AZ2
resource "aws_instance" "bastion_az2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnets[1]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "bastion_az2"
  }
}


# EC2: Application Server 1
resource "aws_instance" "app_az1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnets[0]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(templatefile("${path.module}/deploy.sh", {
    rds_endpoint   = var.rds_endpoint,
    docker_user    = var.dockerhub_username,
    docker_pass    = var.dockerhub_password,
    docker_compose = templatefile("${path.module}/compose.yaml", {
      rds_endpoint = var.rds_endpoint
    })
  }))

  tags = {
    Name = "app_az1"
  }
}


# EC2: Application Server 2
resource "aws_instance" "app_az2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnets[1]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(templatefile("${path.module}/deploy.sh", {
    rds_endpoint   = var.rds_endpoint,
    docker_user    = var.dockerhub_username,
    docker_pass    = var.dockerhub_password,
    docker_compose = templatefile("${path.module}/compose-nomigrations.yaml", {
      rds_endpoint = var.rds_endpoint
    })
  }))

  tags = {
    Name = "app_az2"
  }
}


# Create Application Load balancer Resource
resource "aws_lb" "app" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnets

  tags = {
    Name = "alb"
  }
}


# ALB Routes traffic to Frontend
resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.alb_health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


# Listens to traffic on frontend
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}


# Links "app_az1" to the target group
resource "aws_lb_target_group_attachment" "app_az1" {
  target_group_arn = aws_lb_target_group.frontend.arn
  target_id        = aws_instance.app_az1.id
  port             = 3000
}


# Links "app_az2" to the target group
resource "aws_lb_target_group_attachment" "app_az2" {
  target_group_arn = aws_lb_target_group.frontend.arn
  target_id        = aws_instance.app_az2.id
  port             = 3000
}

