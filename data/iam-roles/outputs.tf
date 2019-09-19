output "cluster_iam_role_name" {
  value = "${data.terraform_remote_state.iam_roles.cluster_iam_role_name}"
}

output "cluster_iam_role_id" {
  value = "${data.terraform_remote_state.iam_roles.cluster_iam_role_id}"
}

output "cluster_iam_role_arn" {
  value = "${data.terraform_remote_state.iam_roles.cluster_iam_role_arn}"
}

output "workers_iam_role_name" {
  value = "${data.terraform_remote_state.iam_roles.workers_iam_role_name}"
}

output "workers_iam_role_id" {
  value = "${data.terraform_remote_state.iam_roles.workers_iam_role_id}"
}

output "workers_iam_role_arn" {
  value = "${data.terraform_remote_state.iam_roles.workers_iam_role_arn}"
}

output "workers_iam_role_policy" {
  value = "${data.terraform_remote_state.iam_roles.workers_iam_role_policy}"
}

output "workers_instance_profile_id" {
  value = "${data.terraform_remote_state.iam_roles.workers_instance_profile_id}"
}

output "workers_instance_profile_name" {
  value = "${data.terraform_remote_state.iam_roles.workers_instance_profile_name}"
}

output "workers_instance_profile_arn" {
  value = "${data.terraform_remote_state.iam_roles.workers_instance_profile_arn}"
}

output "codebuild_service_role_policy_arn" {
  value = "${data.terraform_remote_state.iam_roles.codebuild_service_role_policy_arn}"
}

output "codebuild_service_role_policy_name" {
  value = "${data.terraform_remote_state.iam_roles.codebuild_service_role_policy_name}"
}

output "codebuild_service_role_policy_id" {
  value = "${data.terraform_remote_state.iam_roles.codebuild_service_role_policy_id}"
}

output "codebuild_service_role_arn" {
  value = "${data.terraform_remote_state.iam_roles.codebuild_service_role_arn}"
}

output "codebuild_service_role_name" {
  value = "${data.terraform_remote_state.iam_roles.codebuild_service_role_name}"
}

output "codebuild_service_role_id" {
  value = "${data.terraform_remote_state.iam_roles.codebuild_service_role_id}"
}

output "rds_monitoring_arn" {
  value = "${data.terraform_remote_state.iam_roles.rds_monitoring_arn}"
}
