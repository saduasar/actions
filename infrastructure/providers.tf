/*
data "aws_ssm_parameter" "accesskeys" {
  name = "accesskeys"
}

data "aws_ssm_parameter" "secretkeys" {
  name = "secretkeys"
}
*/

provider "aws" {
  region     = "us-east-1"
}
