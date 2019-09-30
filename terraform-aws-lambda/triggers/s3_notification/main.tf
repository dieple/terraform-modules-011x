resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  count  = "${var.enable}"
  bucket = "${split(",", lookup(var.s3_config, "bucket", ""))}"

  lambda_function {
    lambda_function_arn = "${var.lambda_function_arn}"
    events              = "${split(",", lookup(coalesce(var.s3_config, "events", "")))}"
  }
}
