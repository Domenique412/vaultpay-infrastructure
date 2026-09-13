
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

resource "aws_subnet" "public-a" {

vpc_id = aws_vpc.main.id


}

