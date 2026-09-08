output "bucket_id" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The resource name"
  value       = aws_s3_bucket.this.arn

}

output "bucket_domain_name" {
  description = "The regional domain main of the bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name

}