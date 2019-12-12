output "vpc_id" {
  value = "${data.terraform_remote_state.vpc.vpc_id}"
}

output "vpc_cidr_block" {
  value = "${data.terraform_remote_state.vpc.vpc_cidr_block}"
}

output "vpc_cidr" {
  value = "${data.terraform_remote_state.vpc.vpc_cidr}"
}

output "private_subnets" {
  value = ["${data.terraform_remote_state.vpc.private_subnets}"]
}

output "public_subnets" {
  value = ["${data.terraform_remote_state.vpc.public_subnets}"]
}

output "database_subnets" {
  value = ["${data.terraform_remote_state.vpc.database_subnets}"]
}

output "nat_public_ips" {
  value = ["${data.terraform_remote_state.vpc.nat_public_ips}"]
}

//output "log_group_name" {
//  value = "${data.terraform_remote_state.vpc.log_group_name}"
//}

//output "security_groups" {
//  value = ["${data.terraform_remote_state.vpc.security_groups}"]
//}

output "private_route_table_ids" {
  value = ["${data.terraform_remote_state.vpc.private_route_table_ids}"]
}

output "public_route_table_ids" {
  value = ["${data.terraform_remote_state.vpc.public_route_table_ids}"]
}

output "azs" {
  value = ["${data.terraform_remote_state.vpc.azs}"]
}

output "availability_zones" {
  value = ["${data.terraform_remote_state.vpc.azs}"]
}

output "private_subnets_cidr_blocks" {
  value = ["${data.terraform_remote_state.vpc.private_subnets_cidr_blocks}"]
}

output "public_subnets_cidr_blocks" {
  value = ["${data.terraform_remote_state.vpc.public_subnets_cidr_blocks}"]
}

//output "key_name" {
//  value = "${data.terraform_remote_state.vpc.key_name}"
//}
//
//output "ssh_cidr_block" {
//  value = ["${data.terraform_remote_state.vpc.ssh_cidr_block}"]
//}
