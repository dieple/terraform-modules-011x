output "arn" {
  value = "${data.terraform_remote_state.iam_role_rds_monitoring.arn}"
}

output "id" {
  value = "${data.terraform_remote_state.iam_role_rds_monitoring.id}"
}

output "name" {
  value = "${data.terraform_remote_state.iam_role_rds_monitoring.name}"
}

output "policy" {
  value = "${data.terraform_remote_state.iam_role_rds_monitoring.policy}"
}
