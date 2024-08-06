
resource "aws_launch_template" "template-flex360" {
  name_prefix   = "template-flex360-"
  image_id      = var.ami
  instance_type = var.instance_type

  user_data = filebase64("${path.module}/user_data.sh")
  
  

  lifecycle {
    create_before_destroy = true
  }

}