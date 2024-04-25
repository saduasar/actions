
output "rabbit-primary_console_url" {
  value       = aws_mq_broker.vprofile-rabbitmq.instances.0.console_url 
  description = "AmazonMQ active web console URL"
}