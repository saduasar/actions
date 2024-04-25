resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name        = var.tags["Name"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}