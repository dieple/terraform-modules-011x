data "aws_iam_policy_document" "assume_role" {
  count = "${length(keys(var.principals))}"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "${element(keys(var.principals), count.index)}"
      identifiers = ["${var.principals[element(keys(var.principals), count.index)]}"]
    }
  }
}

module "aggregated_policy" {
  source           = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-aws-iam-policy-document-aggregator"
  source_documents = ["${var.additional_inline_policies}"]
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
  tags                 = "${var.tags}"
}

resource aws_iam_role_policy_attachment "basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = "${aws_iam_role.default.name}"
}

resource aws_iam_role_policy_attachment "additional" {
  count      = "${length(var.addtional_policy_arns)}"
  policy_arn = "${element(var.addtional_policy_arns, count.index)}"
  role       = "${aws_iam_role.default.name}"
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}

resource "aws_iam_instance_profile" "this" {
  count = "${var.create_ec2_profile}"
  name  = "${var.role_name}-profile"
  role  = "${aws_iam_role.default.name}"
  path  = "${var.path}"

  lifecycle {
    create_before_destroy = true
  }
}
