resource "aws_secretsmanager_secret" "db_host" {
  name        = "secrets_database"
  description = "Segredos do banco de dados."
}

resource "aws_secretsmanager_secret_version" "secrets_db" {
  depends_on   = [aws_db_instance.database-flex360]
  secret_id    = aws_secretsmanager_secret.db_host.id
  secret_string = jsonencode({
    DB_HOST     = aws_db_instance.database-flex360.address
    DB_USERNAME = "joao"
    DB_PASSWORD = "senha123"
    DB_PORT     = aws_db_instance.database-flex360.port
  })
}

resource "aws_secretsmanager_secret" "alb_dns" {
  name        = "alb_dns"
  description = "Dns do Load balancer da api"
}

resource "aws_secretsmanager_secret_version" "secret_alb_dns" {
  depends_on   = [aws_lb.alb-flex360]
  secret_id    = aws_secretsmanager_secret.alb_dns.id
  secret_string = jsonencode({
    dns_name = aws_lb.alb-flex360.dns_name
  })
}

//alterado

resource "aws_ssm_parameter" "front_flex360_origin" {
  name  = "front-flex360-origin"
  depends_on = [ aws_cloudfront_distribution.s3_distribution ]
  type  = "String"
  value = join("", ["http://", aws_cloudfront_distribution.s3_distribution.domain_name])
  tags = {
    Name = "flex-360-origin-parameter"
  }
}
