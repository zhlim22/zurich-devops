locals {
  name = "private_ecr_repo"
}

variable "ecr_name" {
  type = string
  description = "ECR Name"
}

variable "ecr_no" {
  type = number
  description = "Number of ECR"
}

output "repository_url" {
  value = aws_ecr_repository.ecr[*].repository_url
}