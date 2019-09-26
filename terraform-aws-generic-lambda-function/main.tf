# Cloudwatch Logs
resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = "${var.cloudwatch_logs_retention_days}"

  tags = "${var.tags}"
}

# Lambda function
resource "aws_lambda_function" "main" {
  function_name    = "${var.function_name}"
  filename         = "${var.artifact_path}/${var.function_name}.zip"
  source_code_hash = "${base64sha256(file("${var.artifact_path}/${var.function_name}.zip"))}"
  description      = "${var.description}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  memory_size      = "${var.memory_size}"
  timeout          = "${var.timeout}"
  role             = "${var.role}"

  depends_on = ["aws_cloudwatch_log_group.main"]

  environment {
    variables = "${var.env_vars}"
  }

  vpc_config {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }

  tags = "${var.tags}"
}

# Add lambda permissions for acting on various triggers.
resource "aws_lambda_permission" "allow_source" {
  count         = "${length(var.source_types)}"
  statement_id  = "AllowExecutionForLambda-${var.source_types[count.index]}"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.main.function_name}"
  principal     = "${var.source_types[count.index]}.amazonaws.com"
  source_arn    = "${var.source_arns[count.index]}"
}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  count  = "${var.aws_s3_bucket_notification == "true" ? 1 : 0}"
  bucket = "${var.aws_s3_bucket_notification_bucket_id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.main.arn}"
    events              = ["${var.aws_s3_bucket_notification_events}"]
  }
}
