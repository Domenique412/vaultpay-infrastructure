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

resource "aws_ecr_repository" "vaultpay" {
  name         = var.project_name
  force_delete = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = "${var.project_name}-ecr"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "runtime" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${var.project_name}-runtime"
  force_destroy = var.s3_force_destroy

  tags = {
    Name    = "${var.project_name}-runtime"
    Project = var.project_name
  }

}

resource "aws_s3_bucket_public_access_block" "vaultpay-pab" {
  bucket = aws_s3_bucket.runtime.id


  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true


}



resource "aws_iam_role" "app" {
  name               = "${var.project_name}-app-role"
  description        = "IAM role assumed by VaultPay EC2 instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name    = "${var.project_name}-app-role"
    Project = var.project_name

  }
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"


}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role_policy" "app_runtime" {
  name   = "${var.project_name}-app-runtime"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.app_runtime.json

}

resource "aws_iam_instance_profile" "app" {
  name = "${var.project_name}-app-profile"
  role = aws_iam_role.app.name

  tags = {
    Name    = "${var.project_name}-app-profile"
    Project = var.project_name

  }
}



resource "aws_launch_template" "app" {
  image_id      = data.aws_ssm_parameter.ami_id.value
  instance_type = "t4g.small"
  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }
  vpc_security_group_ids = [var.app_security_group_id]
  name_prefix            = "${var.project_name}-app"
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project_name}-app"
      Project = var.project_name
    }
  }


  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    aws_region           = data.aws_region.current.region
    ecr_registry         = split("/", aws_ecr_repository.vaultpay.repository_url)[0]
    ecr_repository_url   = aws_ecr_repository.vaultpay.repository_url
    image_tag            = var.image_tag
    db_master_secret_arn = var.db_master_secret_arn
    db_host              = split(":", var.db_endpoint)[0]
    db_port              = var.db_port
    db_name              = var.db_name
    artifact_bucket_name = aws_s3_bucket.runtime.id
  }))

}


resource "aws_autoscaling_group" "app_asg" {

  name                      = "${var.project_name}-app-asg"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.app_private_subnet_ids
  target_group_arns         = [aws_lb_target_group.alb-tg.arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true


  }
}





