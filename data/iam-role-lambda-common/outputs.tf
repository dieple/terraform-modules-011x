output "role_name" {
  value = "${data.terraform_remote_state.iam_role_lambda_common.role_name}"
}

output "role_arn" {
  value = "${data.terraform_remote_state.iam_role_lambda_common.role_arn}"
}

