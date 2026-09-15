

resource "aws_vpc" "main" {

  cidr_block           = var.main-vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
    Project = var.project_name
  }

}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub-subnet-a
  availability_zone = "us-east-1a"
   tags = {
    Name = "${var.project_name}-public-a"
    Project = var.project_name
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub-subnet-b
  availability_zone = "us-east-1b"
    tags = {
    Name = "${var.project_name}-public-b"
    Project = var.project_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

    tags = {
    Name = "${var.project_name}-igw"
    Project = var.project_name
  }
}

resource "aws_route_table" "rt-igw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.pub-route
    gateway_id = aws_internet_gateway.igw.id
  }
    tags = {
    Name = "${var.project_name}-rt-igw"
    Project = var.project_name
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
    Name = "${var.project_name}-private-a-app"
    Project = var.project_name
  }
}

resource "aws_subnet" "private-a-db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-a-db
  availability_zone = "us-east-1a"
    tags = {
    Name = "${var.project_name}-private-a-db"
    Project = var.project_name
  }
}

resource "aws_subnet" "private-b-app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-b-app
  availability_zone = "us-east-1b"
   tags = {
    Name = "${var.project_name}-private-b-app"
    Project = var.project_name
  }
}

resource "aws_subnet" "private-b-db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-b-db
  availability_zone = "us-east-1b"
    tags = {
    Name = "${var.project_name}-private-b-db"
    Project = var.project_name
  }
}



resource "aws_eip" "public-a-eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "public-a-ngw" {
  allocation_id = aws_eip.public-a-eip.id
  subnet_id     = aws_subnet.public-a.id

   tags = {
    Name = "${var.project_name}-public-a-eip"
    Project = var.project_name
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
    Name = "${var.project_name}-rt-ngw"
    Project = var.project_name
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