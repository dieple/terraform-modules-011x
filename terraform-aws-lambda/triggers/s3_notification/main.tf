variable "enable" {
  default = 0
}

variable "lambda_function_arn" {}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  count  = "${var.enable}"
  bucket = ["${lookup(var.s3_config, "bucket")}"]

  lambda_function {
    lambda_function_arn = "${var.lambda_function_arn}"
    events              = ["${lookup(var.s3_config, "events")}"]
  }
}