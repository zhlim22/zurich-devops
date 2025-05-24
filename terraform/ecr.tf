resource "aws_ecr_repository" "ecr" {
  for_each = var.ecr_names
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }

  # data "aws_iam_policy_document" "ecr_policy" {
  #   statement {
  #     sid    = "ECR"
  #     effect = "Allow"
  #
  #     principals {
  #       identifiers = ["arn:aws:iam::479699168399:user/terraform-user"]
  #       type        = "AWS"
  #     }
  #
  #     actions = [
  #       "ecr:GetDownloadUrlForLayer",
  #       "ecr:BatchGetImage",
  #       "ecr:BatchCheckLayerAvailability",
  #       "ecr:PutImage",
  #       "ecr:InitiateLayerUpload",
  #       "ecr:UploadLayerPart",
  #       "ecr:CompleteLayerUpload",
  #       "ecr:DescribeRepositories",
  #       "ecr:GetRepositoryPolicy",
  #       "ecr:ListImages",
  #       "ecr:DeleteRepository",
  #       "ecr:BatchDeleteImage",
  #       "ecr:SetRepositoryPolicy",
  #       "ecr:DeleteRepositoryPolicy",
  #     ]
  #   }
  # }
  #
  # resource "aws_ecr_repository_policy" "private_policy" {
  #   repository = aws_ecr_repository.ecr.name
  #   policy     = data.aws_iam_policy_document.ecr_policy.json
  # }
}