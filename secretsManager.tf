/* resource "aws_secretsmanager_secret" "db_host" {
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

*/

resource "aws_ssm_parameter" "db_secrets" {
  name  = "/prod/secrets/database"
  type  = "SecureString"
  value = jsonencode({
    DB_HOST     = aws_db_instance.database-flex360.address
    DB_USERNAME = "joao"
    DB_PASSWORD = "senha123"
    DB_PORT     = aws_db_instance.database-flex360.port
  })

  description = "Segredos do banco de dados"
}

resource "aws_ssm_parameter" "cache_secrets" {
  name  = "/prod/secrets/cache"
  type  = "SecureString"
  value = jsonencode({
    CACHE_HOST = aws_elasticache_cluster.cache_cluster.primary_endpoint_address
    CACHE_PORT     = 6379
  })

  description = "Segredos do banco de dados"
}

# Criando um parâmetro único para o DNS do Load Balancer
resource "aws_ssm_parameter" "alb_dns" {
  name  = "/prod/secrets/alb_dns"
  type  = "String"                   
  value = aws_lb.alb-flex360.dns_name

  description = "DNS do Load Balancer da API"
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
