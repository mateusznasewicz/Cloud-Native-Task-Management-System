resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]
}

resource "aws_db_instance" "main_db" {
  identifier     = "${var.app_name}-db-instance"
  engine         = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = 10

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible    = false

  skip_final_snapshot = true
}

output "db_address" {
    value = aws_db_instance.main_db.address
}