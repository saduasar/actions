variable "region" {
  description = "Aws Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {}

variable "tags" {
  type = map(string)
  default = {
    Name        = "frontend-servers-sg"
    Name1       = "backend-servers-sg"
    Project     = "vprofile-project"
    Environment = "dev"
  }
}


