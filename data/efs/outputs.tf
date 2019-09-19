# VPC
output "arn" {
  value = "${data.terraform_remote_state.efs.arn}"
}

output "dns_name" {
  value = "${data.terraform_remote_state.efs.dns_name}"
}

output "host" {
  value = "${data.terraform_remote_state.efs.host}"
}

output "id" {
  value = "${data.terraform_remote_state.efs.id}"
}

output "mount_target_dns_names" {
  value = "${data.terraform_remote_state.efs.mount_target_dns_names}"
}

output "mount_target_ids" {
  value = "${data.terraform_remote_state.efs.mount_target_ids}"
}

output "mount_target_ips" {
  value = "${data.terraform_remote_state.efs.mount_target_ips}"
}

output "network_interface_ids" {
  value = "${data.terraform_remote_state.efs.network_interface_ids}"
}
