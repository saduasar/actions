resource "aws_route_table" "public-subnet" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =   var.internet_gateway_id
  }

  tags = {
    Name        = var.tags["Name"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}


resource "aws_route_table" "private-subnet" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

    tags = {
    Name        = var.tags["Name1"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}

#resource "aws_route" "public-RT" {
 # route_table_id            = aws_route_table.public-subnet.id
#  destination_cidr_block    = "0.0.0.0/0"
 # gateway_id = var.internet_gateway_id
#}

## route_table_id            = aws_route_table.private-subnet.id
  #destination_cidr_block    = "0.0.0.0/0" # destination block of code
 # nat_gateway_id = var.nat_gateway_id     # target block of code
#}

resource "aws_route_table_association" "public" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public-subnet.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private-subnet.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = var.public_subnet1_id
  route_table_id = aws_route_table.public-subnet.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = var.private_subnet1_id
  route_table_id = aws_route_table.private-subnet.id
}
