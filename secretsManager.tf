resource "aws_secretsmanager_secret" "db_host" {
  name        = "secrets_database"
  description = "Segredos do banco de dados."
}

resource "aws_secretsmanager_secret_version" "secrets_db" {
  depends_on   = [aws_db_instance.database-flex360]
  secret_id    = aws_secretsmanager_secret.db_host.id
  secret_string = jsonencode({
    host     = aws_db_instance.database-flex360.address
    username = "nome-teste"
    password = "senha123"
    port     = 0000
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

resource "aws_secretsmanager_secret" "secret_s3_name" {
  name        = "s3_name"
  description = "Nome do bucket do s3"
}

resource "aws_secretsmanager_secret_version" "secret_s3_name_version" {
  depends_on   = [aws_s3_bucket.bucket_images]
  secret_id    = aws_secretsmanager_secret.secret_s3_name.id
  secret_string = jsonencode({
    bucket_name = aws_s3_bucket.bucket_images.bucket
  })
}
