variable "region" {
  description = "Aws Region"
  #type        = string
  #default     = "us-east-1"
}

variable "cidr_block" {
  description = "CIDR BLOCK"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "Instance tenancy"
  type        = string
  default     = "default"
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "vprofile-vpc"
    Project     = "vprofile-project"
    Environment = "dev"
  }
}
