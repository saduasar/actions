variable "tags" {
  type = map(string)
  default = {
    Name        = "nginx-frontend-server"
    Name1       = "webapp-backend-server"
    Name2       = "mysql-backend-server"
    Name3       = "rabbitmq-backend-server"
    Name4       = "memcached-backend-server"
    Project     = "vprofile-project"
    Environment = "dev"
  }
}

variable "instance_type1" {
  type = string
}

variable"frontend-servers_sg_id" {}

variable"backend-servers_sg_id" {}

variable "public_subnet_id" {}

variable "private_subnet_id" {}

variable "public_subnet1_id" {}

variable "vpc_id" {}