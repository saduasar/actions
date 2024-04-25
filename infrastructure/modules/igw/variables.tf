variable "region" {
  description = "Aws Region"
 # type        = string
  #default     = "us-east-1"
}

variable "vpc_id" {}

variable "tags" {
  type = map(string)
  default = {
    Name        = "vprofile-igw"
    Project     = "vprofile-project"
    Environment = "dev"
  }
}
