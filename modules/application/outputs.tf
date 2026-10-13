

output "alb_dns_name" {

  description = "The name of the Application LB DNS name"
  value       = aws_lb.vaultpay.dns_name

}
output "alb_security_group_id" {
  description = "The Identifier of the Application LB Security Group "
  value       = aws_security_group.alb.id

}

output "alb_tg_id" {
  description = "The Application Load Balancer Target group Identifier"
  value       = aws_lb_target_group.alb-tg.id

}

output "runtime_bucket_name" {
  description = "Name of the s3 bucket holding VaultPay runtime data"
  value       = aws_s3_bucket.runtime.id

}

output "ecr_repository_url" {
  description = "URL of the ECR repository holding the VaultPay container image"
  value       = aws_ecr_repository.vaultpay.repository_url

}