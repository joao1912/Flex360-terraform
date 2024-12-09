
resource "aws_security_group_rule" "ingress-ec2-flex360-front" {

  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  type                     = "ingress"
  security_group_id        = aws_security_group.sg-ec2-flex360-front.id
  source_security_group_id = aws_security_group.SG-alb-frontend.id

}

resource "aws_security_group_rule" "egress-ec2-flex360-front" {

  protocol          = -1
  from_port         = 0
  to_port           = 0
  type              = "egress"
  security_group_id = aws_security_group.sg-ec2-flex360-front.id
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group" "sg-ec2-flex360-front" {

  name        = "ec2-flex360-front"
  description = "Acesso http via alb do front"
  vpc_id      = aws_vpc.flex360-vpc.id

}

resource "aws_launch_template" "template-flex360-front" {
  name_prefix   = "template-flex360-front-"
  image_id      = var.ami
  instance_type = var.instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_profile.arn
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.sg-ec2-flex360-front.id]
  }

  user_data = filebase64("${path.module}/user_data_front.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "flex360-frontend"
  }

}
