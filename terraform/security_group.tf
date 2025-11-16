resource "aws_security_group" "alb_sg" {
    vpc_id = aws_vpc.main_vpc.id
    name = "${var.app_name}-alb-sg"
    description = "Otwiera port 80"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "frontend_sg" {
    vpc_id = aws_vpc.main_vpc.id
    name = "${var.app_name}-frontend-sg"
    description = "Zezwala na ruch do frontendu tylko z load balancera"

    ingress {
        from_port = var.frontend_port
        to_port = var.frontend_port
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "endpoint_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "${var.app_name}-endpoint-sg"
  description = "Zezwala na ruch HTTPS/443 z Fargate do ECR/S3 Endpoints."

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id] 
  }
}
