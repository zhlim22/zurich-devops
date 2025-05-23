resource "aws_ecr_repository" "ecr" {
  count = var.ecr_no
  name                 = "${local.ecr_name}-${count.index}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}