variable "zone_name" {
  type        = "string"
  description = "Name of the hosted zone"
}

variable "main_vpc" {
  type        = "string"
  description = "Main VPC ID that will be associated with this hosted zone"
}

variable "secondary_vpcs" {
  type        = "list"
  default     = []
  description = "List of VPCs that will also be associated with this zone"
}

variable "force_destroy" {
  type        = "string"
  default     = false
  description = "Whether to destroy all records inside if the hosted zone is deleted"
}

variable "tags" {
  type    = "map"
  default = {}
}
