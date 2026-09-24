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
resource "aws_ecr_repository" "vaultpay" {
  name         = var.project_name
  force_delete = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = "${var.project_name}-ecr"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "runtime" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${var.project_name}-runtime"
  force_destroy = var.s3_force_destroy

  tags = {
    Name    = "${var.project_name}-runtime"
    Project = var.project_name
  }

}

resource "aws_s3_bucket_public_access_block" "vaultpay-pab" {
  bucket = aws_s3_bucket.runtime.id


  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true


}

resource "aws_iam_instance_profile" "vaultpay" {
  name = var.project_name
  role = aws_iam_role.vaultpay.name

tags = {
  Name = "${var.project_name}-instance-profile"
  Project = var.project_name

}
}


resource "aws_iam_role" "vaultpay" {
assume_role_policy = {
    Principal = {
          Service = "ec2.amazonaws.com"
        }

  
}

      tags = {
  Name = "${var.project_name}-iam-role"
  Project = var.project_name

}
}

resource "aws_iam_policy_attachment" "vaultpay-attachment" {
  name       = "vaultpay-attachment"
  
  roles      = [aws_iam_role.vaultpay.name]

  policy_arn = aws_iam_policy.policy.arn
}

