variable "enable" {
  default = 0
}

variable "lambda_function_arn" {}

variable "s3_config" {
  type    = "map"
  default = {}
}
