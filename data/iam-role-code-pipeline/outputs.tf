output "arn" {
  value = "${data.terraform_remote_state.iam_role_code_pipeline.arn}"
}

output "id" {
  value = "${data.terraform_remote_state.iam_role_code_pipeline.id}"
}

output "name" {
  value = "${data.terraform_remote_state.iam_role_code_pipeline.name}"
}

output "policy" {
  value = "${data.terraform_remote_state.iam_role_code_pipeline.policy}"
}
