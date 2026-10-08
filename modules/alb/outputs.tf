

output "alb_dns_name" {

    description = "The name of the Application LB DNS name"
    value = aws_lb.vaultpay.dns_name
  
}
 output "sg_alb_id" {
    description = "The Identifier of the Application LB Security Group "
    value = aws_security_group.alb.id
   
 }

 output "alb_tg_id" {
  description = "The Application Load Balancer Target group Identifier"
  value = aws_lb_target_group.alb-tg.id
  
}