output "internet_gateway" {
  value = aws_internet_gateway.gw
}

output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
}