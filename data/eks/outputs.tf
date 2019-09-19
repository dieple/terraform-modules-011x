output "cluster_id" {
  value = "${data.terraform_remote_state.eks.cluster_id}"
}

output "cluster_arn" {
  value = "${data.terraform_remote_state.eks.cluster_arn}"
}

output "cluster_certificate_authority_data" {
  value = "${data.terraform_remote_state.eks.cluster_certificate_authority_data}"
}

output "cluster_endpoint" {
  value = "${data.terraform_remote_state.eks.cluster_endpoint}"
}

output "cluster_version" {
  value = "${data.terraform_remote_state.eks.cluster_version}"
}

output "cluster_security_group_id" {
  value = "${data.terraform_remote_state.eks.cluster_security_group_id}"
}

output "config_map_aws_auth" {
  value = "${data.terraform_remote_state.eks.config_map_aws_auth}"
}

output "config_map_aws_auth_filename" {
  value = "${data.terraform_remote_state.eks.config_map_aws_auth_filename}"
}

output "cluster_iam_role_name" {
  value = "${data.terraform_remote_state.eks.cluster_iam_role_name}"
}

output "cluster_iam_role_arn" {
  value = "${data.terraform_remote_state.eks.cluster_iam_role_arn}"
}

output "kubeconfig" {
  value = "${data.terraform_remote_state.eks.kubeconfig}"
}

output "kubeconfig_filename" {
  value = "${data.terraform_remote_state.eks.kubeconfig_filename}"
}

output "workers_asg_arns" {
  value = "${data.terraform_remote_state.eks.workers_asg_arns}"
}

output "workers_asg_names" {
  value = "${data.terraform_remote_state.eks.workers_asg_names}"
}

output "workers_user_data" {
  value = "${data.terraform_remote_state.eks.workers_user_data}"
}

output "workers_default_ami_id" {
  value = "${data.terraform_remote_state.eks.workers_default_ami_id}"
}

output "workers_launch_template_ids" {
  value = "${data.terraform_remote_state.eks.workers_launch_template_ids}"
}

output "workers_launch_template_arns" {
  value = "${data.terraform_remote_state.eks.workers_launch_template_arns}"
}

output "workers_launch_template_latest_versions" {
  value = "${data.terraform_remote_state.eks.workers_launch_template_latest_versions}"
}

output "worker_security_group_id" {
  value = "${data.terraform_remote_state.eks.worker_security_group_id}"
}

output "worker_iam_instance_profile_arns" {
  value = "${data.terraform_remote_state.eks.worker_iam_instance_profile_arns}"
}

output "worker_iam_instance_profile_names" {
  value = "${data.terraform_remote_state.eks.worker_iam_instance_profile_names}"
}

output "worker_iam_role_name" {
  value = "${data.terraform_remote_state.eks.worker_iam_role_name}"
}

output "worker_iam_role_arn" {
  value = "${data.terraform_remote_state.eks.worker_iam_role_arn}"
}
