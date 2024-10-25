resource "aws_iam_role" "ec2_role" {
  name = "ec2_ssm_secrets_manager_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_secrets_policy" {
  name        = "SSMAndSecretsManagerFullAccess"
  description = "IAM policy that provides full access to SSM Parameter Store and Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:*",
          "secretsmanager:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_ssm_secrets_policy" {
  name       = "attach_ssm_secrets_policy"
  policy_arn = aws_iam_policy.ssm_secrets_policy.arn
  roles      = [aws_iam_role.ec2_role.name]
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_ssm_secrets_manager_instance_profile"
  role = aws_iam_role.ec2_role.name
}

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

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_profile.arn
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.sg-ec2-flex360.id]
  }

  user_data = filebase64("${path.module}/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

}
