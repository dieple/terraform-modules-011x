data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "ec2" {
  statement {
    sid       = "Ec2Access"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeSubnets",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:DescribeNetworkInterfaceAttribute",
    ]
  }
}

data "aws_iam_policy_document" "efs" {
  statement {
    sid = "EFSAccess"

    actions = [
      "elasticfilesystem:*",
    ]

    resources = ["arn:aws:elasticfilesystem:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:file-system/*"]
    effect    = "Allow"
  }
}

module "eks_efs_provisioner_iam_role" {
  source                   = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-aws-efs-provisioner-iam-role"
  role_name                = "${var.role_name}"
  principals_services_arns = "${var.principals_services_arns}"
  principals_arns          = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_worker_role_name}"]
  role_description         = "${var.role_description}"
  policy_description       = "${var.policy_description}"

  policy_documents = [
    "${data.aws_iam_policy_document.ec2.json}",
    "${data.aws_iam_policy_document.efs.json}",
  ]

  tags = "${var.tags}"
}
