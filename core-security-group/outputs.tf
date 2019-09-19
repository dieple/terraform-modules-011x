output "ssh_access_sg" {
  value = "${aws_security_group.ssh_access_sg.id}"
}

output "elb_access_sg" {
  value = "${aws_security_group.elb_access_sg.id}"
}

output "efs_access_sg" {
  value = "${aws_security_group.efs_access_sg.id}"
}

output "eks_worker_sg" {
  value = "${aws_security_group.eks_worker_sg.id}"
}

output "eks_cluster_sg" {
  value = "${aws_security_group.eks_cluster_sg.id}"
}

output "codebuild_access_sg" {
  value = "${aws_security_group.codebuild_access_sg.id}"
}

output "rds_access_sg" {
  value = "${aws_security_group.rds_access_sg.id}"
}
