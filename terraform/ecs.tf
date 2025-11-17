data "aws_iam_role" "ecs_task_execution_role" {
    name = "LabRole"
}

resource "aws_ecs_cluster" "main_ecs_cluster" {
    name = "ecs-cluster"
}

resource "aws_cloudwatch_log_group" "backend_logs" {
  name = "/ecs/${var.app_name}/backend"
}

resource "aws_cloudwatch_log_group" "frontend_logs" {
    name = "/ecs/${var.app_name}/frontend"
}

resource "aws_ecs_task_definition" "frontend_task" {
    family = "${var.app_name}-frontend-task"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
    cpu = 256
    memory = 512
    container_definitions = jsonencode([
        {
            name      = "frontend-container"
            image     = "${var.ecr_url_frontend}:latest"
            essential = true
            portMappings = [
                {
                    containerPort = var.frontend_port
                    hostPort      = var.frontend_port
                }
            ],
            logConfiguration = {
                logDriver = "awslogs",
                options = {
                    "awslogs-group"         = aws_cloudwatch_log_group.frontend_logs.name,
                    "awslogs-region"        = var.aws_region, 
                    "awslogs-stream-prefix" = "ecs"
                }
            },
            environment = [
                { name = "API_URL", value = aws_lb.app_load_balancer.dns_name }
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "backend_task" {
    family = "${var.app_name}-backend-task"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
    cpu = 256
    memory = 512
    container_definitions = jsonencode([
        {
            name      = "backend-container"
            image     = "${var.ecr_url_backend}:latest"
            essential = true
            environment = [
                { name  = "DB_URL", value = aws_db_instance.main_db.address },
                { name  = "DB_PORT", value = tostring(var.db_port) },
                { name  = "DB_NAME", value = var.db_name },
                { name  = "DB_USER", value = var.db_user },
                { name  = "SERVER_PORT", value = tostring(var.backend_port) },
                { name  = "DB_PASSWORD", value = var.db_password},
                { name = "LOGGING_LEVEL_COM_ZAXXER_HIKARI", value = "DEBUG" },
                { name = "ORIGIN_URL", value = aws_lb.app_load_balancer.dns_name }
            ],
            portMappings = [
                {
                    containerPort = var.backend_port
                    hostPort      = var.backend_port
                }
            ],
            logConfiguration = {
                logDriver = "awslogs",
                options = {
                    "awslogs-group"         = aws_cloudwatch_log_group.backend_logs.name,
                    "awslogs-region"        = var.aws_region, 
                    "awslogs-stream-prefix" = "ecs"
                }
            }
        }
    ])

    depends_on = [ aws_db_instance.main_db ]
}

resource "aws_ecs_service" "frontend_service" {
    name = "${var.app_name}-frontend-service"
    cluster = aws_ecs_cluster.main_ecs_cluster.id
    task_definition = aws_ecs_task_definition.frontend_task.id
    desired_count = 1
    launch_type = "FARGATE"
    force_new_deployment = true

    network_configuration {
      security_groups = [ aws_security_group.container_sg.id ]
      subnets = [ for subnet in aws_subnet.private_subnet : subnet.id ]
    }

    load_balancer {
        container_name = "frontend-container"
        container_port = var.frontend_port
        target_group_arn = aws_lb_target_group.frontend_tg.id
    }
}

resource "aws_ecs_service" "backend_service" {
    name = "${var.app_name}-backend-service"
    cluster = aws_ecs_cluster.main_ecs_cluster.id
    task_definition = aws_ecs_task_definition.backend_task.id
    desired_count = 1
    launch_type = "FARGATE"
    force_new_deployment = true

    network_configuration {
      security_groups = [ aws_security_group.container_sg.id ]
      subnets = [ for subnet in aws_subnet.private_subnet : subnet.id ]
    }

    load_balancer {
        container_name = "backend-container"
        container_port = var.backend_port
        target_group_arn = aws_lb_target_group.backend_tg.id
    }
}