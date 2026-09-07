terraform {
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

resource "aws_s3_bucket" "domadmin-tf-learning-bucket" {
  bucket = "${var.bucket_name}-tf-learning-bucket"

  tags = var.tags


}

resource "aws_s3_bucket_versioning" "domadmin-tf-learning-bucket" {
  bucket = aws_s3_bucket.domadmin-tf-learning-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}