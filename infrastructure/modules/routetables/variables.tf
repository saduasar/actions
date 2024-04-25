variable "region" {
  description = "Aws Region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "vprofile-public-RT"
    Name1       = "vprofile-private-RT"
    Project     = "vprofile-project"
    Environment = "dev"
  }
}

variable "internet_gateway_id" {}

variable "nat_gateway_id" {}

variable "vpc_id" {}

variable "public_subnet_id" {}

variable "public_subnet1_id" {}

variable "private_subnet_id" {}

variable "private_subnet1_id" {}