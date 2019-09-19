variable "peer_vpc_account_id" {
  type        = "string"
  description = "the id of the account that the transit vpc sits in"
}

variable "peer_vpc_id" {
  type        = "string"
  description = "the id of the transit vpc that has the direct connect connection attached"
}

variable "peer_vpc_subnet_cidr" {
  type        = "string"
  description = "CIDR of vpc subnet to route to"
}

variable "requestor_private_subnets" {
  type = "list"
}

variable "requestor_private_route_table_ids" {
  type = "list"
}

variable "requestor_vpc_id" {}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
