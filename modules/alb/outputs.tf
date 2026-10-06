

output "alb_dns_name" {

    description = "The name of the Application LB DNS name"
    value = aws_lb.vaultpay.dns_name
  
}