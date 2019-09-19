output "ssh_access_sg" {
  value = "${data.terraform_remote_state.core_security_group.ssh_access_sg}"
}

output "elb_access_sg" {
  value = "${data.terraform_remote_state.core_security_group.elb_access_sg}"
}

output "efs_access_sg" {
  value = "${data.terraform_remote_state.core_security_group.efs_access_sg}"
}

output "eks_worker_sg" {
  value = "${data.terraform_remote_state.core_security_group.eks_worker_sg}"
}

output "eks_cluster_sg" {
  value = "${data.terraform_remote_state.core_security_group.eks_cluster_sg}"
}

output "codebuild_access_sg" {
  value = "${data.terraform_remote_state.core_security_group.codebuild_access_sg}"
}

output "rds_access_sg" {
  value = "${data.terraform_remote_state.core_security_group.rds_access_sg}"
}
