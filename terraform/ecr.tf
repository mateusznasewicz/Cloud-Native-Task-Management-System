resource "aws_ecr_repository" "frontend_repo" {
    name = var.frontend_repo
    force_delete = true
    image_tag_mutability = "MUTABLE"
    tags = {
        Name = "${var.app_name}-frontend-ecr"
    }
}

resource "aws_ecr_repository" "backend_repo" {
    name = var.backend_repo
    force_delete = true
    image_tag_mutability = "MUTABLE"
    tags = {
        Name = "${var.app_name}-backend-ecr"
    }
}