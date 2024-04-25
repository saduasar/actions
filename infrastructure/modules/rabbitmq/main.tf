data "aws_ssm_parameter" "rabbitmq_username" {
  name = "rabbitmq_user"
}

data "aws_ssm_parameter" "rabbitmq_password" {
  name = "rabbitmq_pass"
}

resource "aws_mq_broker" "vprofile-rabbitmq" {
  broker_name = "rabbitmq"

  engine_type        = "RabbitMQ"
  engine_version     = "3.11.28"
  host_instance_type = "mq.t3.micro"
  security_groups    = [ var.backend-servers_sg_id ]
  subnet_ids         = [ var.private_subnet_id ]

  user {
    username = data.aws_ssm_parameter.rabbitmq_username.value
    password = data.aws_ssm_parameter.rabbitmq_password.value
  }
}