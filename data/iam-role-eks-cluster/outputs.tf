output "arn" {
  value = "${data.terraform_remote_state.iam_role_eks_cluster.arn}"
}

output "id" {
  value = "${data.terraform_remote_state.iam_role_eks_cluster.id}"
}

output "name" {
  value = "${data.terraform_remote_state.iam_role_eks_cluster.name}"
}

output "policy" {
  value = "${data.terraform_remote_state.iam_role_eks_cluster.policy}"
}
