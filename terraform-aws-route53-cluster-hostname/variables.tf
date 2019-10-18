variable "name" {
  description = "The Name of the application or solution  (e.g. `bastion` or `portal`)"
  default     = "dns"
}

variable "zone_id" {
  default     = ""
  description = "Route53 DNS Zone id"
}

variable "records" {
  type        = "list"
  description = "Records"
}

variable "type" {
  default     = "CNAME"
  description = "Type"
}

variable "ttl" {
  default     = "300"
  description = "The TTL of the record to add to the DNS zone to complete certificate validation"
}
