resource "aws_security_group" "SG-alb-frontend" {
  vpc_id = aws_vpc.flex360-vpc.id
  name   = "SG-alb-frontend"
}

resource "aws_security_group_rule" "http_ingress_SG_alb_frontend" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.SG-alb-frontend.id
}

resource "aws_security_group_rule" "egress_SG_alb_frontend" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.SG-alb-frontend.id
}

resource "aws_lb_target_group" "TG_flex360_frontend" {

  name     = "TG-flex360-frontend"
  port     = 80
  vpc_id   = aws_vpc.flex360-vpc.id
  protocol = "HTTP"

  health_check {

    interval            = 50
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 30

  }

}

resource "aws_lb" "alb-flex360-frontend" {

  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG-alb-frontend.id]
  subnets            = [aws_subnet.subnet-public-1.id, aws_subnet.subnet-public-2.id]

  enable_deletion_protection = false

}

resource "aws_lb_listener" "http_frontend" {

  load_balancer_arn = aws_lb.alb-flex360-frontend.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG_flex360_frontend.arn
  }

}