output "asg_id" {
  value = "${aws_autoscaling_group.umsl_asg.id}"
}

output "asg_arn" {
  value = "${aws_autoscaling_group.umsl_asg.arn}"
}

output "autoscaling_group_name" {
  value = "${aws_autoscaling_group.umsl_asg.name}"
}

output "ssh_user" {
  value       = "${var.ssh_user}"
  description = "SSH user"
}

output "security_group_id" {
  value       = "${aws_security_group.umsl_sg.id}"
  description = "Security group ID"
}

output "role" {
  value       = "${aws_iam_role.umsl_role.name}"
  description = "Name of AWS IAM Role associated with the instance"
}

output "public_ip" {
  value       = "${aws_eip.umsl.public_ip}"
  description = "Public IP of the instance (or EIP)"
}

output "private_ip" {
  value       = "${aws_eip.umsl.private_ip}"
  description = "Private IP of the instance"
}
