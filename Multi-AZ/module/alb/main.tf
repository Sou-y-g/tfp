resource "aws_alb" "main" {
  name               = "${var.tag}-alb"
  load_balancer_type = "application"
  #インターネット公開設定
  internal     = false
  idle_timeout = 60
  #enable_deletion_protection = true

  subnets = [
    var.public1_id,
    var.public2_id,
  ]

  security_groups = [
    aws_security_group.http.id,
    aws_security_group.https.id,
    aws_security_group.redirect.id,
  ]
}

#alb リスナー定義
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これはHTTPです"
      status_code  = "200"
    }
  }
}

#############################################################
# Security Group
#############################################################
#http security group
resource "aws_security_group" "http" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  tags = {
    Name = "${var.tag}-http-sg"
  }
}

#https security group
resource "aws_security_group" "https" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  tags = {
    Name = "${var.tag}-https-sg"
  }
}

#redirect security group
resource "aws_security_group" "redirect" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  tags = {
    Name = "${var.tag}-redirect-sg"
  }
}