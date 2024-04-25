resource "aws_elasticache_cluster" "vprofile-memcached" {
  cluster_id           = "vprofile-memcached-cluster"
  engine               = "memcached"
  engine_version       = "1.6.22"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.vprofile-parameter.name
  port                 = 11211
  security_group_ids   = [ var.backend-servers_sg_id ]
  subnet_group_name    = aws_elasticache_subnet_group.vprofile.name
}

resource "aws_elasticache_subnet_group" "vprofile" {
  name       = "vprofile-subnet-group"
  subnet_ids = [ var.private_subnet_id, var.private_subnet1_id ]

  tags = {
    Name = "My Memcache subnet group"
  }
}

resource "aws_elasticache_parameter_group" "vprofile-parameter" {
  name   = "memcache-params"
  family = "memcached1.6"
}


