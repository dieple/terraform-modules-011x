data "aws_region" "current" {}

data "terraform_remote_state" "core_security_group" {
  backend = "s3"

  config {
    bucket = "${var.bucket}"
    key    = "${var.key}"
    region = "${var.region == "" ? data.aws_region.current.name : var.region}"
  }
}
