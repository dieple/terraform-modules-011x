locals {
  description = "Private zone for ${var.zone_name}"
}

resource "aws_route53_zone" "main" {
  name          = "${var.zone_name}"
  comment       = "${local.description}"
  force_destroy = "${var.force_destroy}"
  tags          = "${var.tags}"

  vpc {
    vpc_id = "${var.main_vpc}"
  }
}

resource "aws_route53_zone_association" "secondary" {
  count   = "${length(var.secondary_vpcs)}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  vpc_id  = "${var.secondary_vpcs[count.index]}"
}
