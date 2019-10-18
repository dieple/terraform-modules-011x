output "name" {
  value = "${data.terraform_remote_state.iam_role_eks_worker.name}"
}

output "role_id" {
  value = "${data.terraform_remote_state.iam_role_eks_worker.id}"
}

output "arn" {
  value = "${data.terraform_remote_state.iam_role_eks_worker.arn}"
}

output "policy" {
  value = "${data.terraform_remote_state.iam_role_eks_worker.policy}"
}

output "profile_id" {
  value = "${data.terraform_remote_state.iam_role_eks_worker.profile_id}"
}

output "profile_name" {
  value = "${data.terraform_remote_state.iam_role_eks_worker.profile_name}"
}

output "profile_arn" {
  value = "${data.terraform_remote_state.iam_role_eks_worker.profile_arn}"
}
