variable "vpc_id" {}


variable "tags" {
  type = map(string)
  default = {
    Name        = "vprofile-hostedzones"
    Project     = "vprofile-project"
    Environment = "dev"
  }
}

variable "rds-address-endpoint" {}

variable "memcached-endpoint" {}

variable "rabbit-primary_console_url" {}
