locals {
  ecr_name = "private_ecr"
}

variable "ecr_no" {
  type = number
  description = "Number of ECR"
}

output "repository_url" {
  value = aws_ecr_repository.ecr[*].repository_url
}