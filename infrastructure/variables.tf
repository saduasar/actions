variable "region" {
  description = "Aws Region"
  #type        = string
  #default     = "us-east-1"
}

variable "cidr_block" {
  description = "CIDR BLOCK"
  type        = map(string)
}

variable "instance_type1" {
}