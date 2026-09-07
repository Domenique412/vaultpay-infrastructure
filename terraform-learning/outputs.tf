output "bucket_arn" {
  description = "ARN of the s3 bucket"
  value = aws_s3_bucket.domadmin-tf-learning-bucket.arn
  sensitive = true


}

output "bucket_region" {
    description = "the region the bucket is in"
    value = aws_s3_bucket.domadmin-tf-learning-bucket.bucket_region

  
}