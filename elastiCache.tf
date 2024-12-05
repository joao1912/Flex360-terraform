resource "aws_elasticache_subnet_group" "subnetes_caches" {
  name       = "subnetes-caches"
  subnet_ids = [aws_subnet.subnet-private-3.id, aws_subnet.subnet-private-4.id]
}

resource "aws_elasticache_parameter_group" "redis7_parameter_group" {
  name        = "redis7-parameter-group"
  family      = "redis7"
  description = "Parameter group for Redis 7"
}

resource "aws_elasticache_cluster" "cache_cluster" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.redis7_parameter_group.name
  subnet_group_name    = aws_elasticache_subnet_group.subnetes_caches.name
  port                 = 6379
}
