output "name" {
  value       = "${aws_iam_role.k8s_pods_iam_role.name}"
  description = "The name of the created role"
}

output "id" {
  value       = "${aws_iam_role.k8s_pods_iam_role.id}"
  description = "The stable and unique string identifying the role"
}

output "arn" {
  value       = "${aws_iam_role.k8s_pods_iam_role.arn}"
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "policy" {
  value       = "${aws_iam_role.k8s_pods_iam_role.assume_role_policy}"
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "profile_id" {
  value = "${aws_iam_instance_profile.workers.id}"
}

output "profile_name" {
  value = "${aws_iam_instance_profile.workers.name}"
}

output "profile_arn" {
  value = "${aws_iam_instance_profile.workers.arn}"
}
