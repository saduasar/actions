resource "aws_subnet" "public" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block["cidr1"]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

   tags = {
    Name        = var.tags["Name"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block["cidr3"]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b" // e.g., "us-east-1a"

  tags = {
    Name        = var.tags["Name2"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}


resource "aws_subnet" "private" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block["cidr2"]
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"

   tags = {
    Name        = var.tags["Name1"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.4.0/24" #var.cidr_block["cidr4"]
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1d"

   tags = {
    Name        = var.tags["Name3"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}