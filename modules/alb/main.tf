resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-security-group"
  description = "Security group for VaultPay ALB"
  vpc_id      = var.vpc_id

  egress {
description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name    = "${var.project_name}-alb-security-group"
    Project = var.project_name

  }
}

resource "aws_lb" "vaultpay" {

  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids






  tags = {
    Name    = "${var.project_name}-alb"
    Project = var.project_name

  }
}

resource "aws_lb_target_group" "alb-tg" {
  name        = "${var.project_name}-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    port                = 80
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    path                = "/health"
  }



}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.vaultpay.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn

  }

}



