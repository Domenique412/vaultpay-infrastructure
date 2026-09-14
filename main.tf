
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

  cidr_block           = var.main-vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name    = "vaultpay-vpc"
    Project = "VaultPay"
  }

}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub-subnet-a
  availability_zone = "us-east-1a"
  tags = {
    Name    = "vaultpay-public-subnet-a"
    Project = "VaultPay"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub-subnet-b
  availability_zone = "us-east-1b"
  tags = {
    Name    = "vaultpay-public-subnet-b"
    Project = "VaultPay"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "vaultpay-igw"
    Project = "VaultPay"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.pub-route
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = "vaultpay-public-rt"
    Project = "VaultPay"
  }
}

resource "aws_route_table_association" "rt-pubsub-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rt-pubsub-b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.rt.id
}
