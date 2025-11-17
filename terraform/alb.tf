resource "aws_lb" "app_load_balancer" {
    name = "${var.app_name}-load-balancer"
    load_balancer_type = "application"

    subnets = [ for subnet in aws_subnet.public_subnet : subnet.id ]
    security_groups = [ aws_security_group.alb_sg.id ]
}

resource "aws_lb_listener" "app_alb_listener" {
    load_balancer_arn = aws_lb.app_load_balancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.frontend_tg.arn
    }

    depends_on = [ aws_lb_target_group.frontend_tg ]
}

resource "aws_lb_listener_rule" "api_rule" {
	listener_arn = aws_lb_listener.app_alb_listener.arn

	action {
	  type = "forward"
	  target_group_arn = aws_lb_target_group.backend_tg.arn
	}

	condition {
		path_pattern {
			values = ["/api/*"]
		}
    }

	depends_on = [ aws_lb_target_group.backend_tg ]
}

resource "aws_lb_target_group" "frontend_tg" {
	name = "${var.app_name}-frontend-tg"
	port = var.frontend_port
	protocol = "HTTP"
	vpc_id = aws_vpc.main_vpc.id
	target_type = "ip"

	health_check {
		path                = "/"
		protocol            = "HTTP"
		matcher             = "200"
		interval            = 30
		timeout             = 5
		healthy_threshold   = 2
		unhealthy_threshold = 2
	}
}

resource "aws_lb_target_group" "backend_tg" {
	name = "${var.app_name}-backend-tg"
	port = var.backend_port
	protocol = "HTTP"
	vpc_id = aws_vpc.main_vpc.id
	target_type = "ip"

	health_check {
        path = "/actuator/health"
        protocol = "HTTP"
        matcher = "200"
        interval = 30
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
}

output "alb_dns_name" {
	description = "Publiczny adres DNS ALB"
	value       = aws_lb.app_load_balancer.dns_name 
}