resource "aws_ecr_repository" "ecr" {
  for_each = var.ecr_names
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
}