variable "function_name" {
  description = "Lambda function name"
  type        = "string"
}

variable "runtime" {
  description = "Lambda runtime type"
  type        = "string"
}

variable "memory_size" {
  default     = 128
  description = "Size in MB of Lambda function memory allocation"
  type        = "string"
}

variable "timeout" {
  default     = 60
  description = "Timeout in seconds for Lambda function timeout"
  type        = "string"
}

variable "tags" {
  default     = {}
  description = "Map of tags for Lambda function"
  type        = "map"
}

variable "env_vars" {
  default     = {}
  description = "Map of environment variables for Lambda function"
  type        = "map"
}

variable "subnet_ids" {
  default     = []
  description = "List of subnet IDs for Lambda VPC config (leave empty if no VPC)"
  type        = "list"
}

variable "security_group_ids" {
  default     = []
  description = "List of security group IDs for Lambda VPC config (leave empty if no VPC)"
  type        = "list"
}

variable "cloudwatch_logs_retention_days" {
  default     = 30
  description = "Number of days to retain logs in Cloudwatch Logs"
  type        = "string"
}

variable "source_types" {
  default     = []
  description = "List of sources for Lambda triggers; order must match source_arns"
  type        = "list"
}

variable "source_arns" {
  default     = []
  description = "List of arns for Lambda triggers; order must match source_types"
  type        = "list"
}

variable "environment" {}

variable "aws_s3_bucket_notification" {
  default = "false"
}

variable "aws_s3_bucket_notification_bucket_id" {
  default = ""
}

variable "aws_s3_bucket_notification_events" {
  type    = "list"
  default = []
}

variable "description" {
  default = ""
}

variable "handler" {}

variable "artifact_path" {
  default = "../../../lambda_functions"
}

variable "role_arn" {}
