data "aws_iam_role" "ecs_task_execution_role" {
    name = "LabRole"
}

resource "aws_ecs_cluster" "main_ecs_cluster" {
    name = "ecs-cluster"
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
            ]
        }
    ])
}

resource "aws_ecs_service" "frontend_service" {
    name = "${var.app_name}-frontend-service"
    cluster = aws_ecs_cluster.main_ecs_cluster.id
    task_definition = aws_ecs_task_definition.frontend_task.id
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      security_groups = [ aws_security_group.frontend_sg.id ]
      subnets = [ for subnet in aws_subnet.private_subnet : subnet.id ]
    }

    load_balancer {
        container_name = "frontend-container"
        container_port = var.frontend_port
        target_group_arn = aws_lb_target_group.frontend_tg.id
    }
}