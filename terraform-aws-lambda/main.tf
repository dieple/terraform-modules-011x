locals {
  zipfile              = "${var.lambda_src_artifact_path}/${var.function_name}/${var.function_name}.zip"
  cloudwatch_log_group = "/aws/lambda/${var.function_name}"
}

# Create the lambda function
resource "aws_lambda_function" "lambda" {
  filename                       = "${var.file_name}"
  function_name                  = "${var.function_name}"
  layers                         = ["${var.layers}"]
  handler                        = "${var.handler}"
  role                           = "${var.role_arn}"
  description                    = "${var.description}"
  memory_size                    = "${var.memory_size}"
  runtime                        = "${var.runtime}"
  timeout                        = "${var.timeout}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
  publish                        = "${var.publish}"
  source_code_hash               = "${base64sha256(file("${local.zipfile}"))}"
  vpc_config                     = "${var.vpc_config}"

  environment {
    variables = "${var.env_vars}"
  }

  tags = "${var.tags}"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "${local.cloudwatch_log_group}"
  retention_in_days = "${var.cloudwatch_log_retention}"
}

module "triggered-by-cloudwatch-event-schedule" {
  enable              = "${lookup(var.trigger, "type", "") == "cloudwatch-event-schedule" ? 1 : 0}"
  source              = "./triggers/cloudwatch_event_schedule/"
  lambda_function_arn = "${aws_lambda_function.lambda.arn}"

  schedule_config = {
    name                = "${var.function_name}"
    description         = "${var.description}"
    schedule_expression = "${lookup(var.trigger, "schedule_expression", "")}"
  }
}

module "triggered-by-cloudwatch-event-trigger" {
  enable              = "${lookup(var.trigger, "type", "") == "cloudwatch-event-trigger" ? 1 : 0}"
  source              = "./triggers/cloudwatch_event_trigger/"
  lambda_function_arn = "${aws_lambda_function.lambda.arn}"

  event_config = {
    name          = "${var.function_name}"
    description   = "${var.description}"
    event_pattern = "${lookup(var.trigger, "event_pattern", "")}"
  }
}

module "triggered-by-step-function" {
  enable              = "${lookup(var.trigger, "type", "") == "step-function" ? 1 : 0}"
  source              = "./triggers/step_function/"
  lambda_function_arn = "${aws_lambda_function.lambda.arn}"
  region              = "${var.region}"
}

module "triggered-by-api-gateway" {
  enable              = "${lookup(var.trigger, "type", "") == "api-gateway" ? 1 : 0}"
  source              = "./triggers/api_gateway/"
  lambda_function_arn = "${aws_lambda_function.lambda.arn}"
}

module "triggered-by-cognito-idp" {
  enable              = "${lookup(var.trigger, "type", "") == "cognito-idp" ? 1 : 0}"
  source              = "./triggers/cognito_idp/"
  lambda_function_arn = "${aws_lambda_function.lambda.arn}"
}

module "triggered-by-cloudwatch-logs" {
  enable              = "${lookup(var.trigger, "type", "") == "cloudwatch-logs" ? 1 : 0}"
  source              = "./triggers/cloudwatch_logs/"
  lambda_function_arn = "${aws_lambda_function.lambda.arn}"
  region              = "${var.region}"
}

module "triggered-by-sqs" {
  enable              = "${lookup(var.trigger, "type", "") == "sqs" ? 1 : 0}"
  source              = "./triggers/sqs/"
  lambda_function_arn = "${aws_lambda_function.lambda.arn}"

  sqs_config = {
    sns_topic_arn              = "${lookup(var.trigger, "sns_topic_arn", "")}"
    sqs_name                   = "${var.function_name}"
    visibility_timeout_seconds = "${var.timeout + 5}"
    batch_size                 = "${lookup(var.trigger, "batch_size", 1)}"
  }

  tags = "${var.tags}"
}

module "triggered-by-s3-notification" {
  enable              = "${lookup(var.trigger, "type", "") == "s3" ? 1 : 0}"
  source              = "./triggers/s3_notification/"
  lambda_function_arn = "${aws_lambda_function.lambda.arn}"

  s3_config = {
    bucket = "${lookup(var.trigger, "bucket", "")}"
    events = "${lookup(var.trigger, "events", "")}"
  }
}

module "cloudwatch-log-subscription" {
  enable                      = "${var.enable_cloudwatch_log_subscription ? 1 : 0}"
  source                      = "./log_subscription/"
  lambda_name                 = "${aws_lambda_function.lambda.function_name}"
  log_group_name              = "${aws_cloudwatch_log_group.lambda.name}"
  cloudwatch_log_subscription = "${var.cloudwatch_log_subscription}"
}
