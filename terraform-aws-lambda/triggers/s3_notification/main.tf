resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  count  = "${var.enable}"
  bucket = "${var.bucket}"

  lambda_function {
    lambda_function_arn = "${var.lambda_function_arn}"
    events              = "${split(",", var.events)}"
  }
}
