resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name        = var.tags["Name"]
    Project      = var.tags["Project"]
    Environment = var.tags["Environment"]
  }

  # Enable DNS hostnames for the VPC
  enable_dns_hostnames = true #without this option records with hostnames point to private ips cant resolve. The default aws vpc has this option already set to true.
}