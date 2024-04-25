variable "region" {
  description = "Aws Region"
  type        = string
  default     = "us-east-1"
}

variable "public_subnet_id" {}

variable "tags" {
  type = map(string)
  default = {
    Name        = "vprofile-ngw"
    Project     = "vprofile-project"
    Environment = "dev"
  }
}

variable "internet_gateway" {}