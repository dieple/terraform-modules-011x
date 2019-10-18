output "name" {
  description = "IAM role name."
  value       = "${aws_iam_role.default.name}"
}

output "arn" {
  description = "IAM role ARN."
  value       = "${aws_iam_role.default.arn}"
}

output "id" {
  value       = "${aws_iam_role.default.unique_id}"
  description = "The stable and unique string identifying the role"
}

output "policy" {
  value       = "${aws_iam_policy.default.policy}"
  description = "Role policy document in json format. Outputs always, independent of `enabled` variable"
}
