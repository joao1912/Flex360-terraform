
resource "aws_elasticache_subnet_group" "subnetes_caches" {
  name       = "subnetes_privates_cache"
  subnet_ids = [aws_subnet.subnet-private-1.id, aws_subnet.subnet-private-2.id]

}

resource "aws_elasticache_cluster" "cache_cluster" {

  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  subnet_group_name    = aws_elasticache_subnet_group.subnetes_caches.name
  port                 = 6379

}
