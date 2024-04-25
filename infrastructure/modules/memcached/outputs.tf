output "memcached-endpoint" {
  value = aws_elasticache_cluster.vprofile-memcached.cluster_address
}
