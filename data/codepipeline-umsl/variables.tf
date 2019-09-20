variable "bucket" {
  description = "(Required) The name of the S3 bucket."
}

variable "key" {
  description = "(Required) The path to the state file inside the bucket."
}

variable "region" {
  description = "(Required) The region of the S3 bucket."
  default     = ""
}
