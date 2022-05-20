resource "aws_ecs_cluster" "cluster_django" {
  name = "cluster-ecs"

  setting {
      name  = "containerInsights"
    value = "disabled"
  }
}


resource "aws_ecs_task_definition" "task-def" {
  family                   = "task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = jsonencode([
    {
      name      = "django-container"
      image     = "aogilt/django-app:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ecs_service" "service-django" {
  name            = "django_app"
  launch_type     = "FARGATE" 
  cluster         = aws_ecs_cluster.cluster_django.id
  task_definition = aws_ecs_task_definition.task-def.arn 
  desired_count   = 2
  
  load_balancer {
    target_group_arn = aws_lb_target_group.ip-tg.arn
    container_name   = "django-container"
    container_port   = var.container_port
  }

network_configuration {
    subnets          = [var.private_subnet1_id , var.private_subnet2_id]
    assign_public_ip = false
    security_groups = [
      aws_security_group.sg_django.id
    ]
  }
  depends_on = [
    aws_lb_target_group.ip-tg , aws_security_group.sg_django 
  ]
}

resource "aws_lb" "alb-django" {
  name               = "alb-django"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_django.id]
  subnets            = [var.public_subnet1_id , var.public_subnet2_id] 


  tags = {
    name = "alb-django"
  }

  depends_on = [
    aws_lb_target_group.ip-tg , aws_security_group.sg_django
  ]
}


resource "aws_lb_listener" "listener_django" {
  load_balancer_arn = aws_lb.alb-django.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip-tg.arn
  }

depends_on = [
    aws_lb.alb-django , aws_lb_target_group.ip-tg
  ]
  
}

resource "aws_lb_target_group" "ip-tg" {
  name        = "tg-Prueba-Simetrik"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "sg_django" {
  name        = "sg_django"
  description = "Allow traffic to django app"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Security group Prueba Simetrik"
  }
}

resource "aws_ecr_repository" "ecr_simetrik" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"


  image_scanning_configuration {
    scan_on_push = true
  }
}
