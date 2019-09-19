data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "repository" {
  count = "${length(var.repository_names)}"
  name  = "${element(var.repository_names, count.index)}"
  tags  = "${var.tags}"
}

resource "aws_ecr_repository_policy" "policy" {
  repository = "${element(aws_ecr_repository.repository.*.name, count.index)}"
  count      = "${length(aws_ecr_repository.repository.*.name)}"

  policy = "${var.allow_push == "true" ? data.aws_iam_policy_document.ecr_policy_read_write.json : data.aws_iam_policy_document.ecr_policy_read_only.json}"
}

data "aws_iam_policy_document" "ecr_policy_read_only" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "${formatlist("arn:aws:iam::%s:root", var.allowed_account_ids)}",
      ]
    }
  }
}

data "aws_iam_policy_document" "ecr_policy_read_write" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "${formatlist("arn:aws:iam::%s:root", var.allowed_account_ids)}",
      ]
    }
  }
}

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = "${element((keys(var.repo_lifecycle_info)), count.index)}"
  count      = "${length(keys(var.repo_lifecycle_info))}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last provided number of tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ${jsonencode(slice(var.repo_lifecycle_info[element((keys(var.repo_lifecycle_info)), count.index)], 2, length(var.repo_lifecycle_info[element((keys(var.repo_lifecycle_info)), count.index)])))},
                "countType": "imageCountMoreThan",
                "countNumber": ${element(var.repo_lifecycle_info[element((keys(var.repo_lifecycle_info)), count.index)], 1)}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Expire unatagged images older than the provided number days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${element(var.repo_lifecycle_info[element((keys(var.repo_lifecycle_info)), count.index)], 0)}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
