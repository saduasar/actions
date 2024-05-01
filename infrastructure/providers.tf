data "aws_ssm_parameter" "accesskeys" {
  name = "accesskeys"
}

data "aws_ssm_parameter" "secretkeys" {
  name = "secretkeys"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.aws_ssm_parameter.accesskeys.value
  secret_key = data.aws_ssm_parameter.secretkeys.value
}
