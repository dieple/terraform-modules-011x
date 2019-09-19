resource "aws_iam_instance_profile" "this" {
  name_prefix = "${var.name}"
  role        = "${aws_iam_role.this.name}"
  path        = "${var.path}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "this" {
  name_prefix           = "${var.name}"
  path                  = "${var.path}"
  description           = "${var.description}"
  force_detach_policies = "${var.force_detach_policies}"
  assume_role_policy    = "${data.aws_iam_policy_document.this.json}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.name}"
  role   = "${aws_iam_role.this.name}"
  policy = "${var.policy}"

  lifecycle {
    create_before_destroy = true
  }
}
