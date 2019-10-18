output "name" {
  value       = "${module.eks_efs_provisioner_iam_role.name}"
  description = "The name of the created role"
}

output "id" {
  value       = "${module.eks_efs_provisioner_iam_role.id}"
  description = "The stable and unique string identifying the role"
}

output "arn" {
  value       = "${module.eks_efs_provisioner_iam_role.arn}"
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "policy" {
  value       = "${module.eks_efs_provisioner_iam_role.policy}"
  description = "The Amazon Resource Name (ARN) specifying the role"
}
