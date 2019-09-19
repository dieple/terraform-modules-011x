variable "zone_name" {}

variable "records" {
  type = "list"
}

variable "ttl_default" {
  default = 300
}

variable "tags" {
  type = "map"
}
