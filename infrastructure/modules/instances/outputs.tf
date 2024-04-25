output "webapp_private_ip" {
  value = aws_instance.webapp-backend-server.private_ip
}

output "memcached_private_ip" {
  value = aws_instance.memcached-backend-server.private_ip
}

output "rabbitmq_private_ip" {
  value = aws_instance.rabbitmq-backend-server.private_ip
}

output "db_private_ip" {
  value = aws_instance.mysql-backend-server.private_ip
}

