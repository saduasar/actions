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

#variable "access_keys" {
 # type = string
 # default = "AKIARKUQDDELU5NALFPF"
#}

#variable "secret_keys" {
 # type = string
 # default = "n0TELfotHTCEnR/TWAgyHejMrnZZnymZ3I784dwQ"
  
#}
