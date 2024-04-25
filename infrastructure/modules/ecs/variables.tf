variable "tags" {
  type = map(string)
  default = {
    Project     = "vprofile-project"
    Environment = "dev"
  }
}

variable "region" {}

variable "vpc_id" {}

variable"frontend-servers_sg_id" {}

variable"backend-servers_sg_id" {}

variable "public_subnet_id" {}

variable "private_subnet_id" {}

variable "public_subnet1_id" {}