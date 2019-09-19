variable "name" {}
variable "vpc_id" {}

variable "ssh_cidr_block" {
  type = "list"
}

variable "tags" {
  type = "map"
}

variable "elb_cidr_block" {
  type = "list"
}

variable "office_cidr_block" {
  type = "list"
}

variable "vpc_cidr_block" {
  type = "list"
}

variable "ri_cidr_block" {
  type    = "list"
  default = ["10.0.0.0/8"]
}

variable "rds_port" {}
