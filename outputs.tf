output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.application.alb_dns_name
}

output "ecr_repository_url" {
  description = "URL of the VaultPay ECR repository"
  value       = module.application.ecr_repository_url
}

output "runtime_bucket_name" {
  description = "Name of the VaultPay runtime bucket"
  value       = module.application.runtime_bucket_name
}