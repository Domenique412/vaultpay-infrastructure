terraform {

  backend "s3" {
    bucket       = "domadmin-s3-terraform-state-029637202564-us-east-1-an"
    key          = "terraform-learning/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

  }

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

module "bucket" {

  source = "./modules"

  bucket_name = var.bucket_name
  Environment = "dev"

}