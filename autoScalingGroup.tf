
resource "aws_autoscaling_group" "flex360-autoScaling" {

  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size
  depends_on = [ aws_ssm_parameter.db_secrets ]

  launch_template {
    id      = aws_launch_template.template-flex360.id
    version = "$Latest"

  }

  vpc_zone_identifier = [aws_subnet.subnet-private-1.id, aws_subnet.subnet-private-2.id]

  target_group_arns = [aws_lb_target_group.TG_flex360.arn]

}