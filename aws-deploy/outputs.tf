/*
  Stack Outputs.
*/

# iam role and policy
output "iam_role_arn" {
  value = "${module.iam_role.arn}"
}

output "iam_role_unique_id" {
  value = "${module.iam_role.unique_id}"
}

output "iam_role_profile_name" {
  value = "${module.iam_role.profile_name}"
}

# load balancer
output "elb_dns_name" {
  value = "${module.elb.this_elb_dns_name}"
}

# security group
output "ec2_security_group_id" {
  value = "${module.ec2_sg.this_security_group_id}"
}

output "ec2_security_group_name" {
  value = "${module.ec2_sg.this_security_group_name}"
}

output "elb_security_group_id" {
  value = "${module.elb_sg.this_security_group_id}"
}

output "elb_security_group_name" {
  value = "${module.elb_sg.this_security_group_name}"
}

# launch configuration
output "launch_configuration_id" {
  value = "${module.asg.this_launch_configuration_id}"
}

output "launch_configuration_name" {
  value = "${module.asg.this_launch_configuration_name}"
}

# autoscaling group
output "autoscaling_group_id" {
  value = "${module.asg.this_autoscaling_group_id}"
}

output "autoscaling_group_name" {
  value = "${module.asg.this_autoscaling_group_name}"
}

output "autoscaling_group_arn" {
  value = "${module.asg.this_autoscaling_group_arn}"
}
