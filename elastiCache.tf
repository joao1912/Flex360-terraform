resource "aws_security_group" "SG-cache" {
  vpc_id = aws_vpc.flex360-vpc.id
  name   = "SG-cache"
}

resource "aws_security_group_rule" "access_cache_ingress" {
  type                     = "ingress"
  source_security_group_id = aws_security_group.sg-ec2-flex360.id
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.SG-cache.id
}

resource "aws_security_group_rule" "access_cache_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.SG-cache.id
}

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
  security_group_ids   = [aws_security_group.SG-cache.id]
}
