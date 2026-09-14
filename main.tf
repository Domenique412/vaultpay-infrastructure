
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

resource "aws_route_table" "rt-igw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.pub-route
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = "vaultpay-public-rt-igw"
    Project = "VaultPay"
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.rt-igw.id
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.rt-igw.id
}



resource "aws_subnet" "private-a-app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-a-app
  availability_zone = "us-east-1a"
  tags = {
    Name    = "vaultpay-private-subnet-application-a"
    Project = "VaultPay"
  }
}

resource "aws_subnet" "private-a-db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-a-db
  availability_zone = "us-east-1a"
  tags = {
    Name    = "vaultpay-private-subnet-database-a"
    Project = "VaultPay"
  }
}

resource "aws_subnet" "private-b-app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-b-app
  availability_zone = "us-east-1b"
  tags = {
    Name    = "vaultpay-private-subnet-application-a"
    Project = "VaultPay"
  }
}

resource "aws_subnet" "private-b-db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-b-db
  availability_zone = "us-east-1b"
  tags = {
    Name    = "vaultpay-private-subnet-database-a"
    Project = "VaultPay"
  }
}



resource "aws_eip" "public-a-eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "public-a-ngw" {
  allocation_id = aws_eip.public-a-eip.id
  subnet_id     = aws_subnet.public-a.id

  tags = {
    Name    = "vaultpay-public-a-ngw"
    Project = "VaultPay"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "rt-ngw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.pub-route
    gateway_id = aws_nat_gateway.public-a-ngw.id
  }
  tags = {
    Name    = "vaultpay-public-rt-ngw"
    Project = "VaultPay"
  }
}

resource "aws_route_table_association" "private-a-app" {
  subnet_id      = aws_subnet.private-a-app.id
  route_table_id = aws_route_table.rt-ngw.id
}


resource "aws_route_table_association" "private-b-app" {
  subnet_id      = aws_subnet.private-b-app.id
  route_table_id = aws_route_table.rt-ngw.id
}