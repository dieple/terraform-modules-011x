variable "role_name" {
  type = "string"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "principals_services_arns" {
  type        = "list"
  default     = ["ec2.amazonaws.com"]
  description = "List of Services identifiers to allow assuming the role."
}

variable "principals_arns" {
  type        = "list"
  description = "List of ARNs to allow assuming the role. Could be AWS accounts, Kops nodes, IAM users or groups"
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
