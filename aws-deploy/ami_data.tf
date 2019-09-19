//################
//# AMI ID Output
//################
//data "aws_ami" "ami" {
//  most_recent = true
//
//  filter {
//    name   = "name"
//    values = ["${var.ami_name}"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//
//  filter {
//    name   = "tag:Version"
//    values = ["${var.ami_version}"]
//  }
//
//  owners = ["245334408285"]
//}

