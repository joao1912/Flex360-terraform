resource "aws_security_group_rule" "ingress-ec2-flex360" {

  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-ec2-flex360.id
  source_security_group_id = aws_security_group.SG-alb.id

}

resource "aws_security_group_rule" "egress-ec2-flex360" {

  protocol          = -1
  from_port         = 0
  to_port           = 0
  type              = "egress"
  security_group_id = aws_security_group.sg-ec2-flex360.id
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group" "sg-ec2-flex360" {

  name        = "ec2-flex360"
  description = "Acesso http via alb"
  vpc_id      = aws_vpc.flex360-vpc.id

}

resource "aws_launch_template" "template-flex360" {
  name_prefix   = "template-flex360-"
  image_id      = var.ami
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.sg-ec2-flex360.id]
  }

  user_data = filebase64("${path.module}/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

}