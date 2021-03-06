variable "file_name" {
  description = "lambda function filename name"
}

variable "layers" {
  description = "List of layers for this lambda function"
  type        = "list"
  default     = []
}

variable "function_name" {
  description = "lambda function name"
}

variable "handler" {
  description = "lambda function handler"
}

variable "role_arn" {
  description = "lambda function role arn"
}

variable "description" {
  description = "lambda function description"
  default     = "Managed by Terraform"
}

variable "memory_size" {
  description = "lambda function memory size"
  default     = 128
}

variable "runtime" {
  description = "lambda function runtime"
  default     = "nodejs10.x"
}

variable "timeout" {
  description = "lambda function runtime"
  default     = 300
}

variable "publish" {
  description = "Publish lambda function"
  default     = false
}

variable "vpc_config" {
  type = "map"
}

variable "env_vars" {
  description = "lambda environment variables"
  type        = "map"
  default     = {}
}

variable "trigger" {
  description = "trigger configuration for this lambda function"
  type        = "map"
}

variable "cloudwatch_log_subscription" {
  description = "cloudwatch log stream configuration"
  type        = "map"
  default     = {}
}

variable "tags" {
  description = "Tags for this lambda function"
  default     = {}
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions  for this lambda function"
  default     = -1
}

variable "region" {
  description = "AWS region"
}

variable "enable_cloudwatch_log_subscription" {
  default = false
}

variable "cloudwatch_log_retention" {
  default = 90
}

variable "lambda_src_artifact_path" {
  default = "../../../lambda_artifacts"
}
