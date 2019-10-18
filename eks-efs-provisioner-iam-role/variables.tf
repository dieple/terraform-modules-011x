variable "role_name" {
  type = "string"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "eks_worker_role_name" {
  type = "string"
}

variable "principals_services_arns" {
  type        = "list"
  default     = ["ec2.amazonaws.com"]
  description = "List of Services identifiers to allow assuming the role."
}

variable "role_description" {
  type        = "string"
  description = "The description of the IAM role that is visible in the IAM role manager"
}

variable "policy_description" {
  type        = "string"
  description = "The description of the IAM policy that is visible in the IAM policy manager"
}
