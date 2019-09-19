resource "aws_vpc_peering_connection" "transit_vpc" {
  peer_owner_id = "${var.peer_vpc_account_id}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  vpc_id        = "${var.requestor_vpc_id}"
  tags          = "${var.tags}"
}

resource "aws_route" "transit_vpc" {
  count                     = "${length(var.requestor_private_subnets)}"
  route_table_id            = "${element(var.requestor_private_route_table_ids, count.index)}"
  destination_cidr_block    = "${var.peer_vpc_subnet_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.transit_vpc.id}"
}
