output "arn" {
  value = "${data.terraform_remote_state.iam_role_efs_provisioner.arn}"
}

output "id" {
  value = "${data.terraform_remote_state.iam_role_efs_provisioner.id}"
}

output "name" {
  value = "${data.terraform_remote_state.iam_role_efs_provisioner.name}"
}

output "policy" {
  value = "${data.terraform_remote_state.iam_role_efs_provisioner.policy}"
}
