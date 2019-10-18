variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "principals" {
  type        = "map"
  description = "Map of service name as key and a list of ARNs to allow assuming the role as value. (e.g. map(`AWS`, list(`arn:aws:iam:::role/admin`)))"
  default     = {}
}

variable "policy_documents" {
  type        = "list"
  description = "List of JSON IAM policy documents"
  default     = []
}

variable "max_session_duration" {
  default     = 3600
  description = "The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours"
}

variable "role_description" {
  type        = "string"
  description = "The description of the IAM role that is visible in the IAM role manager"
}

variable "policy_description" {
  type        = "string"
  description = "The description of the IAM policy that is visible in the IAM policy manager"
}

variable "create_ec2_profile" {
  default = false
}

variable "path" {
  description = "If provided, all IAM roles will be created on this path."
  default     = "/"
}

variable "role_name" {}

variable "addtional_policy_arns" {
  description = "Optional additional attached IAM policy ARNs."
  type        = "list"
  default     = []
}
