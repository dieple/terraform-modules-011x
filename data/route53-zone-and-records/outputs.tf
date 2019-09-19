output "zone_name" {
  value = "${data.terraform_remote_state.route53_zone_and_records.zone_name}"
}

output "zone_id" {
  value = "${data.terraform_remote_state.route53_zone_and_records.zone_id}"
}
