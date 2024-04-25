resource "aws_ecs_cluster" "vprofile-cluster" {
  name = "vprofile-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
  tags = {
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
}

resource "aws_ecs_cluster_capacity_providers" "vp-capacity" {
  cluster_name = aws_ecs_cluster.vprofile-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "vprofile-app-task_definition" {
  family                   = "vprofile"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                       = 1024
  memory                    = 2048
  execution_role_arn       = "arn:aws:iam::091570247959:role/ecsTaskExecutionRole"

  container_definitions = <<TASK_DEFINITION
[
  {
    "name":        "vproapp",
    "image":       "091570247959.dkr.ecr.us-east-1.amazonaws.com/vrpofileimg:ecr_vp",
    "cpu":          1024,
    "memory":       2048,
    "essential":   true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort":      8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs",
        "awslogs-create-group": "true"
      }
    }
  }
]
TASK_DEFINITION



  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


resource "aws_ecs_service" "vprofile-app-service" {
  name            = "vprofile-app-service"
  cluster         = aws_ecs_cluster.vprofile-cluster.id
  task_definition = aws_ecs_task_definition.vprofile-app-task_definition.arn
  desired_count   = 3
  network_configuration {
    subnets = [var.private_subnet_id]
    security_groups = [var.backend-servers_sg_id]
    assign_public_ip = false
  }
   
  # this block of code will attach the tasks(containers) to your created load balancer, so you dont need to created a seperate aws_lb_target_group_attachment resoruce
  load_balancer {
    target_group_arn = aws_lb_target_group.vprofile-target-group.arn
    container_name   = "vproapp"
    container_port   = 8080
    }
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

resource "aws_lb_target_group" "vprofile-target-group" {
  name     = "vp-tg"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
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

  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = 86400
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.vprofile.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vprofile-target-group.arn
  }
}

#resource "aws_lb_target_group_attachment" "vp-attach-tg" {
 # target_group_arn = aws_lb_target_group.vprofile-target-group.arn
  #target_id        = aws_ecs_service.vprofile-app-service.id
  #port             = 8080
#}


