resource "aws_iam_user" "default" {
  name          = "${var.user_id}"
  path          = "${var.path}"
  force_destroy = "${var.force_destroy}"
  tags          = "${var.tags}"
}

resource "aws_iam_access_key" "default" {
  user = "${aws_iam_user.default.name}"

  //  pgp_key = "${var.pgp_key}"
  pgp_key = "${base64encode(file("${var.pgp_key}"))}"
}

resource "aws_iam_user_policy" "default" {
  name   = "${aws_iam_user.default.name}-policy"
  user   = "${aws_iam_user.default.name}"
  policy = "${var.policy}"
}
