variable "kms_name" {
  type        = "string"
  description = "Application or solution name (e.g. `app`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "deletion_window_in_days" {
  default     = 10
  description = "Duration in days after which the key is deleted after destruction of the resource"
}

variable "enable_key_rotation" {
  default     = "true"
  description = "Specifies whether key rotation is enabled"
}

variable "description" {
  type        = "string"
  default     = "Parameter Store KMS master key"
  description = "The description of the key as viewed in AWS console"
}

variable "alias" {
  type        = "string"
  default     = ""
  description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash"
}
