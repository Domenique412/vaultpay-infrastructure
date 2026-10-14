resource "aws_ecr_repository" "vaultpay" {
  name = var.project_name
  force_delete = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-ecr"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "runtime" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.project_name}-runtime"
  force_destroy = var.s3_force_destroy

  tags = {
    Name = "${var.project_name}-runtime"
  Project = var.project_name
  }

}

resource "aws_s3_bucket_public_access_block" "vaultpay-pab" {
  bucket = aws_s3_bucket.runtime.id


  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true


}
