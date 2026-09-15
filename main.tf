terraform {
  required_version = "~> 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
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
  project_name = var.project_name
  
}