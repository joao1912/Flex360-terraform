
resource "aws_security_group" "SG-alb" {
  vpc_id = aws_vpc.flex360-vpc.id
  name   = "SG-alb"

}

resource "aws_security_group_rule" "http_ingress_SG_alb" {
  type                     = "ingress"
  source_security_group_id = aws_security_group.sg-ec2-flex360-front.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.SG-alb.id

}

resource "aws_security_group_rule" "egress_SG_alb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.SG-alb.id
}

resource "aws_lb_target_group" "TG_flex360" {

  name     = "TG-flex360"
  port     = 80
  vpc_id   = aws_vpc.flex360-vpc.id
  protocol = "HTTP"

  health_check {

    interval            = 50
    path                = "/health"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 30

  }

}

resource "aws_lb" "alb-flex360" {

  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG-alb.id]
  subnets            = [aws_subnet.subnet-private-1.id, aws_subnet.subnet-private-2.id]

  enable_deletion_protection = false

}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb-flex360.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG_flex360.arn
  }

}