output "public_subnet_ids" {
  description = "A list of the public subnet identifiers"
  value = [
    aws_subnet.public-a.id,
    aws_subnet.public-b.id
  ]

}

output "alb_dns_name" {

    description = "The name of the Application LB DNS name"
    value = aws_lb.vaultpay.dns_name
  
}