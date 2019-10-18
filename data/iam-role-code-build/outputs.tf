output "arn" {
  value = "${data.terraform_remote_state.iam_role_code_build.arn}"
}

output "id" {
  value = "${data.terraform_remote_state.iam_role_code_build.id}"
}

output "name" {
  value = "${data.terraform_remote_state.iam_role_code_build.name}"
}

output "policy" {
  value = "${data.terraform_remote_state.iam_role_code_build.policy}"
}
