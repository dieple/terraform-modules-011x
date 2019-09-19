variable "force_destroy" {
  description = "Destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices."
  default     = "false"
}

variable "path" {
  description = "Path in which to create the user"
  default     = "/"
}

variable "pgp_key" {
  description = "map of users pgp public keys. YOU MUST PROVIDE ONE!"
}

variable "user_id" {}

variable "tags" {
  type    = "map"
  default = {}
}

variable "policy" {
  //  type        = "map"
  description = "List of JSON IAM policy documents"
  default     = ""
}
