
terraform {

  required_version = "~>1.16.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }

  }
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/20"

  enable_dns_hostnames = true

  enable_dns_support = true

  tags = {
    Name    = "vaultpay-vpc"
    Project = "VaultPay"
  }

}

