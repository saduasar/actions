resource "aws_instance" "nginx-frontend-server" {
   ami           = "ami-0c7217cdde317cfec"
   subnet_id     = var.public_subnet_id
   instance_type = var.instance_type1
   key_name               = "web-keypair" 
   vpc_security_group_ids = [var.frontend-servers_sg_id]
   associate_public_ip_address = true
  
   tags = {
    Name        = var.tags["Name"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]  
   }
   #user_data = "${file("~/OneDrive/Desktop/IT/Devops/terraform/Demos/vprofile-project/modules/instances/nginx.sh")}"
}

resource "aws_instance" "webapp-backend-server" {
  ami           = "ami-0df2a11dd1fe1f8e3"
  subnet_id     = var.private_subnet_id
  instance_type = var.instance_type1
  key_name               = "web-keypair" 
  vpc_security_group_ids = [var.backend-servers_sg_id]
  
   tags = {
    Name        = var.tags["Name1"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
    user_data = "${file("~/OneDrive/Desktop/IT/Devops/terraform/Demos/vprofile-project/modules/instances/webapp.sh")}"
}


resource "aws_instance" "mysql-backend-server" {
  ami           = "ami-0df2a11dd1fe1f8e3"
  subnet_id     = var.private_subnet_id
  instance_type = var.instance_type1
  key_name               = "web-keypair" 
  vpc_security_group_ids = [var.backend-servers_sg_id]
  
   tags = {
    Name        = var.tags["Name2"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
    user_data = "${file("~/OneDrive/Desktop/IT/Devops/terraform/Demos/vprofile-project/modules/instances/db.sh")}"

  depends_on = [aws_instance.webapp-backend-server]

}

resource "aws_instance" "rabbitmq-backend-server" {
  ami           = "ami-0df2a11dd1fe1f8e3"
  subnet_id     = var.private_subnet_id
  instance_type = var.instance_type1
  key_name               = "web-keypair" 
  vpc_security_group_ids = [var.backend-servers_sg_id]
  
   tags = {
    Name        = var.tags["Name3"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
    user_data = "${file("~/OneDrive/Desktop/IT/Devops/terraform/Demos/vprofile-project/modules/instances/rabbitmq.sh")}"

  depends_on = [aws_instance.webapp-backend-server]

}

resource "aws_instance" "memcached-backend-server" {
  ami           = "ami-0df2a11dd1fe1f8e3"
  subnet_id     = var.private_subnet_id
  instance_type = var.instance_type1
  key_name               = "web-keypair" 
  vpc_security_group_ids = [var.backend-servers_sg_id]
  
   tags = {
    Name        = var.tags["Name4"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
    user_data = "${file("~/OneDrive/Desktop/IT/Devops/terraform/Demos/vprofile-project/modules/instances/memcached.sh")}"

  depends_on = [aws_instance.webapp-backend-server, aws_instance.mysql-backend-server]
}

resource "aws_lb" "vprofile" {
  name               = "vprofile-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.frontend-servers_sg_id]
  subnets            = [var.public_subnet1_id, var.public_subnet_id, var.private_subnet_id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}


resource "aws_lb_target_group" "test" {
  name     = "vp-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/login"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.vprofile.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.webapp-backend-server.id
  port             = 8080
}


