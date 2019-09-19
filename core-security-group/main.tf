provider "aws" {
  region = "eu-west-1"
}

resource "aws_security_group" "rds_access_sg" {
  name        = "${var.name}-sg"
  description = "Default rds security group that allows inbound and outbound traffic from RI"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-rds", var.name)))}"
}

resource "aws_security_group_rule" "rds_access_ingress" {
  type              = "ingress"
  from_port         = "${var.rds_port}"
  to_port           = "${var.rds_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.ri_cidr_block}"]
  security_group_id = "${aws_security_group.rds_access_sg.id}"
}

resource "aws_security_group_rule" "rds_access_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.rds_access_sg.id}"
}

resource "aws_security_group" "codebuild_access_sg" {
  name        = "${var.name}-codebuild-sg"
  description = "Default codebuild security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-codebuild", var.name)))}"
}

resource "aws_security_group_rule" "codebuild_access_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${var.vpc_cidr_block}"]
  security_group_id = "${aws_security_group.codebuild_access_sg.id}"
}

resource "aws_security_group_rule" "codebuild_access_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.codebuild_access_sg.id}"
}

resource "aws_security_group" "ssh_access_sg" {
  name        = "${var.name}-ssh-sg"
  description = "Default ssh security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-ssh", var.name)))}"
}

resource "aws_security_group_rule" "ssh_access_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ssh_cidr_block}"
  security_group_id = "${aws_security_group.ssh_access_sg.id}"
}

resource "aws_security_group_rule" "ssh_access_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = "${var.ssh_cidr_block}"
  security_group_id = "${aws_security_group.ssh_access_sg.id}"
}

resource "aws_security_group" "elb_access_sg" {
  name        = "${var.name}-elb-sg"
  description = "Default ELB security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-elb", var.name)))}"
}

resource "aws_security_group_rule" "elb_access_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = "${var.elb_cidr_block}"
  security_group_id = "${aws_security_group.elb_access_sg.id}"
}

resource "aws_security_group_rule" "elb_access_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = "${var.elb_cidr_block}"
  security_group_id = "${aws_security_group.elb_access_sg.id}"
}

resource "aws_security_group" "efs_access_sg" {
  name        = "${var.name}-efs-sg"
  description = "Default ELB security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-efs", var.name)))}"
}

resource "aws_security_group_rule" "efs_access_ingress" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.efs_access_sg.id}"
  source_security_group_id = "${aws_security_group.ssh_access_sg.id}"
}

resource "aws_security_group_rule" "efs_access_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.efs_access_sg.id}"
}

resource "aws_security_group" "eks_worker_sg" {
  name        = "${var.name}-eks-worker-sg"
  description = "Default EKS Workers security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-eks-worker", var.name)))}"
}

resource "aws_security_group_rule" "eks_worker_ssh_access_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ssh_cidr_block}"
  security_group_id = "${aws_security_group.eks_worker_sg.id}"
}

resource "aws_security_group_rule" "eks_worker_8080_ingress" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks_worker_sg.id}"
  cidr_blocks       = "${var.office_cidr_block}"
}

resource "aws_security_group_rule" "eks_worker_all_access_self_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  self              = "true"
  security_group_id = "${aws_security_group.eks_worker_sg.id}"
}

resource "aws_security_group_rule" "eks_worker_all_access_elb_self_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  self              = "true"
  security_group_id = "${aws_security_group.elb_access_sg.id}"
}

resource "aws_security_group_rule" "eks_worker_ingress_with_source_security_group_id" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_worker_sg.id}"
  source_security_group_id = "${aws_security_group.eks_cluster_sg.id}"
}

resource "aws_security_group_rule" "eks_worker_ingress_extension_api_8080" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_worker_sg.id}"
  source_security_group_id = "${aws_security_group.eks_cluster_sg.id}"
}

resource "aws_security_group_rule" "eks_worker_ingress_extension_api_1025_65535" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  security_group_id        = "${aws_security_group.eks_worker_sg.id}"
  source_security_group_id = "${aws_security_group.eks_cluster_sg.id}"
}

resource "aws_security_group_rule" "eks_worker_access_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.eks_worker_sg.id}"
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.name}-eks-cluster-sg"
  description = "Default EKS Cluster security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-eks-cluster", var.name)))}"
}

resource "aws_security_group_rule" "eks_cluster_443_ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_cluster_sg.id}"
  source_security_group_id = "${aws_security_group.eks_worker_sg.id}"
}

resource "aws_security_group_rule" "eks_cluster_access_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.eks_cluster_sg.id}"
}

resource "aws_security_group_rule" "eks_cluster_all_protocols_ports" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  security_group_id        = "${aws_security_group.eks_cluster_sg.id}"
  source_security_group_id = "${aws_security_group.eks_worker_sg.id}"
}
