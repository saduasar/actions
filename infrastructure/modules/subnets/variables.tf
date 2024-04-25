variable "region" {
  description = "Aws Region"
  type        = string
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "CIDR BLOCK"
  type        = map(string)
  #default     =  {
   # cidr1 = "10.0.1.0/24"
   # cidr2 = "10.0.2.0/24" 
   # cidr3 = "10.0.3.0/24"
  #}
}

variable "vpc_id" {}

variable "tags" {
  type = map(string)
  default = {
    Name        = "vprofile-sub-public"
    Name1       = "vprofile-sub-private"
    Name2      = "vprofile-sub-public2"
    Name3      = "vprofile-sub-private2"
    Project     = "vprofile-project"
    Environment = "dev"
  }
}
