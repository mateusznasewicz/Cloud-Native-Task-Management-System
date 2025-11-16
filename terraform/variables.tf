variable "frontend_repo" {
    type = string
}

variable "backend_repo" {
    type = string
}

variable "app_name" {
    type = string
}

variable "aws_region" {
    type = string
}

variable "frontend_port" {
    type = number
}

variable "backend_port" {
    type = number
}

variable "ecr_url_frontend" {
    type = string
}

variable "ecr_url_backend" {
    type = string
}