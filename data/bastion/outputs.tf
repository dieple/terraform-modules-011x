# iam role and policy
output "iam_role_arn" {
  value = "${data.terraform_remote_state.bastion.iam_role_arn}"
}

output "iam_role_unique_id" {
  value = "${data.terraform_remote_state.bastion.iam_role_unique_id}"
}

output "iam_role_profile_name" {
  value = "${data.terraform_remote_state.bastion.iam_role_profile_name}"
}

# load balancer
output "elb_dns_name" {
  value = "${data.terraform_remote_state.bastion.elb_dns_name}"
}

# security group
output "ec2_security_group_id" {
  value = "${data.terraform_remote_state.bastion.ec2_security_group_id}"
}

output "ec2_security_group_name" {
  value = "${data.terraform_remote_state.bastion.ec2_security_group_name}"
}

output "elb_security_group_id" {
  value = "${data.terraform_remote_state.bastion.elb_security_group_id}"
}

output "elb_security_group_name" {
  value = "${data.terraform_remote_state.bastion.elb_security_group_name}"
}

# launch configuration
output "launch_configuration_id" {
  value = "${data.terraform_remote_state.bastion.launch_configuration_id}"
}

output "launch_configuration_name" {
  value = "${data.terraform_remote_state.bastion.launch_configuration_name}"
}

# autoscaling group
output "autoscaling_group_id" {
  value = "${data.terraform_remote_state.bastion.autoscaling_group_id}"
}

output "autoscaling_group_name" {
  value = "${data.terraform_remote_state.bastion.autoscaling_group_name}"
}

output "autoscaling_group_arn" {
  value = "${data.terraform_remote_state.bastion.autoscaling_group_arn}"
}
