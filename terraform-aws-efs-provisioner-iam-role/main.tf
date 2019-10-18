data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["${var.principals_services_arns}"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${var.principals_arns}"]
    }
  }
}

module "aggregated_policy" {
  source           = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-aws-iam-policy-document-aggregator"
  source_documents = ["${var.policy_documents}"]
}

resource "aws_iam_policy" "default" {
  name        = "${var.role_name}-policy"
  description = "${var.policy_description}"
  policy      = "${module.aggregated_policy.result_document}"
}

resource "aws_iam_role" "default" {
  name                 = "${var.role_name}"
  assume_role_policy   = "${data.aws_iam_policy_document.assume_role.json}"
  description          = "${var.role_description}"
  max_session_duration = "${var.max_session_duration}"
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}
