resource "aws_db_subnet_group" "vaultpay" {
  name        = "vaultpay-db-subnet-group"
  subnet_ids  = module.vpc.db_private_subnet_ids
  description = "Subnets for VaultPay RDS placement"
  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name

  }
}

resource "aws_security_group" "rds" {
  name        = "vaultpay-rds-security-group"
  description = "Security group for VaultPay RDS"
  vpc_id      = module.vpc.vpc_id

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name    = "${var.project_name}-rds-security-group"
    Project = var.project_name

  }
}