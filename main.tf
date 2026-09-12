
terraform {

  required_version = "~>1.16.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }

  }
}

resource "aws_vpc" "main" {

  cidr_block = var.main-vpc

  enable_dns_hostnames = true

  enable_dns_support = true

  tags = {
    Name    = "vaultpay-vpc"
    Project = "VaultPay"
  }

}

list "aws_subnet" "vaultpay-public-subnet-a" {


  config {
    filter {
      name   = "tag:Project"
      values = ["VaultPay"]
    }

    filter {
      name   = "tag:Name"
      values = "vaultpay-public-subnet-a"
    }

    filter {
      cidr_block = var.pub-subnet-a
    }
  }
}



