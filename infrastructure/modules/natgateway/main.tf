resource "aws_eip" "nat_eip" {
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat_eip.id  # Reference the ID of the Elastic IP
  subnet_id     = var.public_subnet_id #where the subnet reside aka public subnet

  depends_on = [var.internet_gateway]

  tags = {
    Name        = var.tags["Name"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}

