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

  multi_az                 = var.multi_az
  project_name             = var.project_name
  app_private_subnet_cidrs = var.app_private_subnet_cidrs
  db_name                  = var.db_name
  db_username              = var.db_name
  backup_retention_period  = var.backup_retention_period
  skip_final_snapshot      = var.skip_final_snapshot
  deletion_protection      = var.deletion_protection
  vpc_id                   = module.vpc.vpc_id
  db_private_subnet_ids    = module.vpc.db_private_subnet_ids
}