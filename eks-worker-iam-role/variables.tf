variable "eks_cluster_name" {}

variable "iam_path" {
  description = "If provided, all IAM roles will be created on this path."
  default     = "/"
}

variable "permissions_boundary" {
  description = "If provided, all IAM roles will be created with this permissions boundary attached."
  default     = ""
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "role_name" {}
