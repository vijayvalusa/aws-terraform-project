#Create App-server target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     =  4000      #Application listening on port 4000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "app-tg"
  }
}


#Create Application load balancer
resource "aws_lb" "ilb" {
  name               = "app-ilb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.ilb_sg
  subnets            = var.app_subnet_ids  # Ideally add at least two public subnets
  tags = {
    Name = "app-ilb"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.ilb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

#---
#Create web-server target Group
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80      #Application listening on port 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "web-tg"
  }
}


#Create Application load balancer
resource "aws_lb" "alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg
  subnets            = var.web_subnet_ids   # Ideally add at least two public subnets
  tags = {
    Name = "web-alb"
  }
}



#ACM certificate
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn

  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   =  data.aws_acm_certificate.selected.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


data "aws_acm_certificate" "selected" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
  most_recent = true
}


