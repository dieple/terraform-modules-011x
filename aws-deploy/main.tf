# labels resource for naming and tags
module "label" {
  source      = "git::https://github.com/dieple/terraform-modules-011x.git//terraform-terraform-label"
  namespace   = "${var.namespace}"
  name        = "${var.name}"
  stage       = "${var.stage}"
  delimiter   = "${var.delimiter}"
  attributes  = "${var.attributes}"
  tags        = "${var.tags}"
  enabled     = "${var.enabled}"
  cost_centre = "${var.cost_centre}"
  project     = "${var.project}"
}

# iam role and policy
module "iam_role" {
  source = "https://github.com/dieple/terraform-modules-011x.git//ec2-iam-role"
  name   = "${module.label.id}"
  policy = "${var.policy}"
}

# security group and rules
# ec2 security group
module "ec2_sg" {
  source                                = "https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=tags/v2.17.0"
  name                                  = "${module.label.id}"
  vpc_id                                = "${var.vpc_id}"
  ingress_with_source_security_group_id = "${var.ec2_ingress_with_source_security_group_id}"
  ingress_with_cidr_blocks              = "${var.ec2_ingress_with_cidr_blocks}"
  ingress_with_self                     = "${var.ec2_ingress_with_self}"
  egress_with_source_security_group_id  = "${var.ec2_egress_with_source_security_group_id}"
  egress_with_cidr_blocks               = "${var.ec2_egress_with_cidr_blocks}"
  egress_with_self                      = "${var.ec2_egress_with_self}"
  tags                                  = "${module.label.tags}"
}

# elb security group
module "elb_sg" {
  source                                = "https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=tags/v2.17.0"
  name                                  = "${module.label.id}-elb"
  vpc_id                                = "${var.vpc_id}"
  ingress_with_source_security_group_id = "${var.elb_ingress_with_source_security_group_id}"
  ingress_with_cidr_blocks              = "${var.elb_ingress_with_cidr_blocks}"
  ingress_with_self                     = "${var.elb_ingress_with_self}"
  egress_with_source_security_group_id  = "${var.elb_egress_with_source_security_group_id}"
  egress_with_cidr_blocks               = "${var.elb_egress_with_cidr_blocks}"
  egress_with_self                      = "${var.elb_egress_with_self}"
  tags                                  = "${module.label.tags}"
}

# elastic load balancer
module "elb" {
  source                      = "git::https://github.com/dieple/terraform-modules-011x.git//elb"
  name                        = "${module.label.id}"
  subnets                     = ["${var.subnets}"]
  security_groups             = ["${module.elb_sg.this_security_group_id}"]
  internal                    = "${var.internal}"
  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"
  listener                    = ["${var.listener}"]
  access_logs                 = ["${var.access_logs}"]
  health_check                = ["${var.health_check}"]
  tags                        = "${module.label.tags}"
}

# autoscaling
module "asg" {
  source                      = "git::https://github.com/dieple/terraform-modules-011x.git//autoscaling-group"
  name                        = "${module.label.id}"
  lc_name                     = "${module.label.id}-lc"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${module.iam_role.profile_name}"
  key_name                    = "${var.key_name}"
  security_groups             = "${concat(list("${module.ec2_sg.this_security_group_id}"), "${var.security_groups}")}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.custom_user_data ? var.user_data : data.template_file.user_data_script.rendered}"
  enable_monitoring           = "${var.enable_monitoring}"
  placement_tenancy           = "${var.placement_tenancy}"
  ebs_optimized               = "${var.ebs_optimized}"
  ebs_block_device            = "${var.ebs_block_device}"
  ephemeral_block_device      = "${var.ephemeral_block_device}"
  asg_name                    = "${module.label.id}-asg"
  vpc_zone_identifier         = ["${var.vpc_zone_identifier}"]
  min_size                    = "${var.min_size}"
  max_size                    = "${var.max_size}"
  desired_capacity            = "${var.desired_capacity}"
  min_elb_capacity            = "${var.min_elb_capacity}"
  load_balancers              = ["${module.elb.this_elb_id}"]
  health_check_type           = "${var.health_check_type}"
  termination_policies        = "${var.termination_policies}"
  tags_as_map                 = "${module.label.tags}"
  enable_autoscaling_schedule = "${var.enable_autoscaling_schedule}"
  scale_down_desired_capacity = "${var.scale_down_desired_capacity}"
  scale_down_min_size         = "${var.scale_down_min_size}"
  scale_up_cron               = "${var.scale_up_cron}"
  scale_down_cron             = "${var.scale_down_cron}"
}
