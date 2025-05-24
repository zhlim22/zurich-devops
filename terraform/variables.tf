variable "ecr_names" {
  type = set(string)
  description = "ECR Names"
}

output "repository_url" {
  value = [for inst in aws_ecr_repository.ecr : inst.repository_url]
}