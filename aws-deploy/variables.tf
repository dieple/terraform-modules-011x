variable "namespace" {
  type        = "string"
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = "string"
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "environment" {
  type        = "string"
  default     = ""
  description = "Environment, e.g. 'testing', 'UAT'"
}

variable "name" {
  type        = "string"
  default     = "app"
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "cost_centre" {
  default = ""
}

variable "project" {
  default = ""
}

variable "enabled" {
  type        = "string"
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources"
  default     = "true"
}

variable "tags" {
  description = "A list of tag blocks. Each element should have keys named key, value, and propagate_at_launch."
  default     = []
}

variable "region" {
  type        = "string"
  description = "AWS region to use"
  default     = "eu-west-1"
}

variable "ami_version" {
  default = ""
}

variable "ami_name" {
  default = ""
}

# iam
variable "policy" {
  description = "(Required) The policy document. This is a JSON formatted string"
}

# sg - common
variable "vpc_id" {
  default = "(Required) ID of the VPC where to create security group"
}

# sg - ec2
variable "ec2_ingress_with_source_security_group_id" {
  type        = "list"
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "ec2_ingress_with_cidr_blocks" {
  type        = "list"
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "ec2_ingress_with_self" {
  type        = "list"
  description = "List of ingress rules to create where 'self' is defined"
  default     = []
}

variable "ec2_egress_with_source_security_group_id" {
  description = "List of egress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "ec2_egress_with_cidr_blocks" {
  type        = "list"
  description = "List of egress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "ec2_egress_with_self" {
  type        = "list"
  description = "List of egress rules to create where 'self' is defined"
  default     = []
}

# sg - elb
variable "elb_ingress_with_source_security_group_id" {
  type        = "list"
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "elb_ingress_with_cidr_blocks" {
  type        = "list"
  description = "List of ingress rules to create where 'cidr_blocks' is used."
  default     = []
}

variable "elb_ingress_with_self" {
  type        = "list"
  description = "List of ingress rules to create where 'self' is defined."
  default     = []
}

variable "elb_egress_with_source_security_group_id" {
  description = "List of egress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "elb_egress_with_cidr_blocks" {
  type        = "list"
  description = "List of egress rules to create where 'cidr_blocks' is used."
  default     = []
}

variable "elb_egress_with_self" {
  type        = "list"
  description = "List of egress rules to create where 'self' is defined."
  default     = []
}

# elb
variable "subnets" {
  description = "A list of subnet IDs to attach to the ELB"
  type        = "list"
}

variable "internal" {
  description = "If true, ELB will be an internal ELB"
  default     = true
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  default     = true
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  default     = 60
}

variable "connection_draining" {
  description = "Boolean to enable connection draining"
  default     = true
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain"
  default     = 300
}

variable "listener" {
  description = "A list of listener blocks"
  type        = "list"
}

variable "access_logs" {
  description = "An access logs block"
  type        = "list"
  default     = []
}

variable "health_check" {
  description = "A health check block"
  type        = "list"
}

# autoscaling
# asg
variable "max_size" {
  default     = 3
  description = "The maximum size of the auto scale group"
}

variable "min_size" {
  default     = 3
  description = "The minimum size of the auto scale group"
}

variable "desired_capacity" {
  default     = 3
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "min_elb_capacity" {
  default     = 3
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
}

variable "health_check_type" {
  default     = "EC2"
  description = "Controls how health checking is done. Values are - EC2 and ELB"
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type        = "list"
  default     = ["OldestLaunchConfiguration"]
}

variable "vpc_zone_identifier" {
  description = "(Required) A list of subnet IDs to launch resources in"
  type        = "list"
}

# lc
variable "custom_user_data" {
  default     = false
  description = "Is a custom user_data script required?"
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  default     = ""
}

variable "service_name" {
  default     = ""
  description = "The name of the service to start via user_data"
}

variable "instance_type" {
  default     = "t2.medium"
  description = "The size of instance to launch"
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the launch configuration"
  type        = "list"
  default     = []
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  default     = false
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring. This is enabled by default."
  default     = true
}

variable "placement_tenancy" {
  description = "The tenancy of the instance. Valid values are 'default' or 'dedicated'"
  default     = "default"
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = "list"
  default     = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as 'Instance Store') volumes on the instance"
  type        = "list"
  default     = []
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = "list"

  default = [
    {
      volume_size = "20"
      volume_type = "gp2"
    },
  ]
}

variable "enable_autoscaling_schedule" {
  description = "Is autoscaling group scheduled?"
  default     = false
}

variable "scale_down_desired_capacity" {
  type        = "string"
  description = "The number of instances that should be running when scaling down."
  default     = 1
}

variable "scale_down_min_size" {
  type        = "string"
  description = "Minimum number of instances that can be running when scaling down"
  default     = 1
}

variable "scale_up_cron" {
  type        = "string"
  description = "In UTC, when to scale up the servers"
  default     = "0 7 * * MON-FRI"
}

variable "scale_down_cron" {
  type        = "string"
  description = "In UTC, when to scale down the servers"
  default     = "0 0 * * SUN-SAT"
}
