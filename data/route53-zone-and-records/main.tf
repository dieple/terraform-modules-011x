data "aws_region" "current" {}

data "terraform_remote_state" "route53_zone_and_records" {
  backend = "s3"

  config {
    bucket = "${var.bucket}"
    key    = "${var.key}"
    region = "${var.region == "" ? data.aws_region.current.name : var.region}"
  }
}
