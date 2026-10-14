terraform {
  required_version = "~> 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {

  region = "us-east-1"

}


module "vpc" {
  source = "./modules/vpc"

  main-vpc      = var.main-vpc
  pub-subnet-a  = var.pub-subnet-a
  pub-subnet-b  = var.pub-subnet-b
  pub-route     = var.pub-route
  private-a-app = var.private-a-app
  private-a-db  = var.private-a-db
  private-b-app = var.private-b-app
  private-b-db  = var.private-b-db
  project_name  = var.project_name

}

module "database" {

  source = "./modules/database"

  multi_az                = var.multi_az
  project_name            = var.project_name
  app_security_group_id   = aws_security_group.app.id
  db_name                 = var.db_name
  db_username             = var.db_username
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  vpc_id                  = module.vpc.vpc_id
  db_private_subnet_ids   = module.vpc.db_private_subnet_ids
}

module "application" {

  source = "./modules/application"

  app_private_subnet_ids = module.vpc.app_private_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  project_name           = var.project_name
  public_subnet_ids      = module.vpc.public_subnet_ids
  image_tag              = var.image_tag
  db_master_secret_arn   = module.database.db_master_secret_arn
  db_name                = module.database.db_name
  db_endpoint            = module.database.db_endpoint
  db_port                = module.database.db_port
  app_security_group_id  = aws_security_group.app.id
  ecr_force_delete       = var.ecr_force_delete
  s3_force_destroy       = var.s3_force_destroy
}



resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-security-group"
  description = "Security group for VaultPay application"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name    = "${var.project_name}-app-security-group"
    Project = var.project_name

  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = module.application.alb_security_group_id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "HTTP from the application load balancer"
}


