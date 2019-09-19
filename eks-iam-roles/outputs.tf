output "cluster_iam_role_name" {
  value       = "${aws_iam_role.cluster.name}"
  description = "The name of the created role"
}

output "cluster_iam_role_id" {
  value       = "${aws_iam_role.cluster.id}"
  description = "The stable and unique string identifying the role"
}

output "cluster_iam_role_arn" {
  value       = "${aws_iam_role.cluster.arn}"
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "workers_iam_role_name" {
  value       = "${aws_iam_role.k8s_pods_iam_role.name}"
  description = "The name of the created role"
}

output "workers_iam_role_id" {
  value       = "${aws_iam_role.k8s_pods_iam_role.id}"
  description = "The stable and unique string identifying the role"
}

output "workers_iam_role_arn" {
  value       = "${aws_iam_role.k8s_pods_iam_role.arn}"
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "workers_iam_role_policy" {
  value       = "${aws_iam_role.k8s_pods_iam_role.assume_role_policy}"
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "codebuild_iam_role_name" {
  value = "${aws_iam_role.codebuild_iam_role.name}"
}

output "codebuild_iam_role_id" {
  value = "${aws_iam_role.codebuild_iam_role.id}"
}

output "codebuild_iam_role_arn" {
  value = "${aws_iam_role.codebuild_iam_role.arn}"
}

output "workers_instance_profile_id" {
  value = "${aws_iam_instance_profile.workers.id}"
}

output "workers_instance_profile_name" {
  value = "${aws_iam_instance_profile.workers.name}"
}

output "workers_instance_profile_arn" {
  value = "${aws_iam_instance_profile.workers.arn}"
}

output "codebuild_service_role_policy_arn" {
  value = "${aws_iam_policy.codebuild_service_role_policy.arn}"
}

output "codebuild_service_role_policy_name" {
  value = "${aws_iam_policy.codebuild_service_role_policy.name}"
}

output "codebuild_service_role_policy_id" {
  value = "${aws_iam_policy.codebuild_service_role_policy.id}"
}

output "codebuild_service_role_arn" {
  value = "${aws_iam_role.codebuild_iam_role.arn}"
}

output "codebuild_service_role_name" {
  value = "${aws_iam_role.codebuild_iam_role.name}"
}

output "codebuild_service_role_id" {
  value = "${aws_iam_role.codebuild_iam_role.id}"
}

output "rds_monitoring_arn" {
  value = "${aws_iam_role.rds_enhanced_monitoring.arn}"
}
