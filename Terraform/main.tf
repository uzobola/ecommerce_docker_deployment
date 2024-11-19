# My root main.tf

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "ec2" {
  source                = "./modules/ec2"
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnet_ids
  private_subnets       = module.vpc.private_subnet_ids
  instance_type         = var.instance_type
  key_name              = var.key_name
  ami_id                = var.ami_id
  dockerhub_username    = var.dockerhub_username
  dockerhub_password    = var.dockerhub_password
  rds_endpoint          = aws_db_instance.main.endpoint
  alb_health_check_path = var.alb_health_check_path
}

# RDS: Database Security Group
resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.ec2.app_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-rds-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "ecommerce-db-subnet"
  subnet_ids = module.vpc.private_subnet_ids

  tags = {
    Name = "ecommerce-db-subnet-group"
  }
}

# Initialize RDS instance
resource "aws_db_instance" "main" {
  identifier           = "ecommerce-db"
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp2"
  db_name              = "ecommerce"
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "ecommerce-rds"
  }
}


# New monitoring configuration
# Get default VPC information
data "aws_vpc" "default" {
  default = true
}

data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# Create VPC Peering connection
resource "aws_vpc_peering_connection" "monitoring" {
  peer_vpc_id = data.aws_vpc.default.id
  vpc_id      = module.vpc.vpc_id
  auto_accept = true

  tags = {
    Name = "monitoring-peer"
  }
}


# Add route to default VPC route table
resource "aws_route" "default_to_app" {
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.monitoring.id
}


# Add routes to application VPC private route tables
resource "aws_route" "app_to_default" {
  route_table_id            = module.vpc.private_route_table_id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.monitoring.id
}



# Add Node Exporter access to application security group
resource "aws_security_group_rule" "allow_node_exporter" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  security_group_id = module.ec2.app_sg_id
  cidr_blocks       = [data.aws_vpc.default.cidr_block]
}


