output "id" {
  value = "${aws_vpc_peering_connection.transit_vpc.id}"
}

output "accept_status" {
  value       = "${aws_vpc_peering_connection.transit_vpc.accept_status}"
  description = "Normalized name"
}
