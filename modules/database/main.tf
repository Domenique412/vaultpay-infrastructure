resource "aws_db_subnet_group" "vaultpay" {
  name        = "vaultpay-db-subnet-group"
  subnet_ids  = var.db_private_subnet_ids
  description = "Subnets for VaultPay RDS placement"
  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name

  }
}

resource "aws_security_group" "rds" {
  name        = "vaultpay-rds-security-group"
  description = "Security group for VaultPay RDS"
  vpc_id      = var.vpc_id

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = var.app_private_subnet_cidrs
}

  tags = {
    Name    = "${var.project_name}-rds-security-group"
    Project = var.project_name

  }
}

resource "aws_db_instance" "vaultpay" {

  # General settings
  allocated_storage = 20
  identifier        = "${var.project_name}-db"
  engine            = "postgres"
  engine_version    = "18.1"
  instance_class    = "db.t4g.micro"
  db_name           = var.db_name

  # Credentials
  username                    = var.db_username
  manage_master_user_password = true


  # Storage 
  storage_type      = "gp3"
  storage_encrypted = true

  # Network Access
  db_subnet_group_name   = aws_db_subnet_group.vaultpay.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Environment settings (hardcoded)
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  tags = {
    Name    = "${var.project_name}-db-instance"
    Project = var.project_name

  }



}