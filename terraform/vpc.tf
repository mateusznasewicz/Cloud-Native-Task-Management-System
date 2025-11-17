data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true 
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.${count.index+1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.app_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.${count.index+127}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.app_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}

resource "aws_route_table" "routing_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "routing_table_assoc" {
  count = 2
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.routing_table.id
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"

  subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]
  security_group_ids = [aws_security_group.endpoint_sg.id ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoint_sg.id] 
  private_dns_enabled = true
  subnet_ids          = [for s in aws_subnet.private_subnet : s.id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoint_sg.id]
  private_dns_enabled = true
  subnet_ids          = [for s in aws_subnet.private_subnet : s.id]
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.main_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.private_routing.id] 
}

resource "aws_route_table" "private_routing" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.app_name}-private-routing"
  }
}

resource "aws_route_table_association" "private_routing_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_routing.id
}