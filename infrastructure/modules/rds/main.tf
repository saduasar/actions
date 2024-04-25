data "aws_ssm_parameter" "db_username" {
  name = "db_username"
}

data "aws_ssm_parameter" "db_password" {
  name = "db_password"
}

resource "aws_db_instance" "vprofile-db" {
  allocated_storage      = 10
  db_name                = "accounts"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = "db.t3.micro"
  username               = data.aws_ssm_parameter.db_username.value
  password               = data.aws_ssm_parameter.db_password.value
  multi_az               = false
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   =   aws_db_subnet_group.vprofile.name
  vpc_security_group_ids = [ var.backend-servers_sg_id, ]
  skip_final_snapshot    = true

  tags = {
    Name        = "${var.tags["Name"]}-db"
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}

resource "aws_db_subnet_group" "vprofile" {
  name       = "vprofile-subnet-group"
  subnet_ids = [ var.private_subnet_id, var.private_subnet1_id ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_instance" "rds-connect-ec2" {
  ami                         = "ami-080e1f13689e07408" #ubuntu 22.04
  subnet_id                   = var.public_subnet1_id
  instance_type               = var.instance_type1
  key_name                    = "web-keypair"
  vpc_security_group_ids      = [var.frontend-servers_sg_id]
  associate_public_ip_address = true

  tags = {
    Name        = var.tags["Name"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
  #user_data = "${file("~/OneDrive/Desktop/IT/Devops/terraform/Demos/vprofile-project/modules/instances/nginx.sh")}"

  depends_on = [aws_db_instance.vprofile-db]

  provisioner "file" {
    content     = templatefile("templates/init_db.tmpl", { rds-endpoint = aws_db_instance.vprofile-db.address, dbuser = data.aws_ssm_parameter.db_username.value, dbpass = data.aws_ssm_parameter.db_password.value })
    destination = "/tmp/vprofile-db_init.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key)
      host        = self.public_ip
    }
   }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/vprofile-db_init.sh",
      "sudo /tmp/vprofile-db_init.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key)
      host        = self.public_ip
    }
  }
}

