data "aws_kms_secrets" "github_tokens" {
  secret {
    name    = "github_oauth_token"
    payload = "${var.github_oauth_token}"
  }

  secret {
    name    = "github_webhooks_token"
    payload = "${var.github_webhooks_token}"
  }
}

resource "aws_codebuild_webhook" "pipeline_webhook" {
  project_name  = "${aws_codebuild_project.codebuild_docker_image.name}"
  branch_filter = "master"
  depends_on    = ["aws_codebuild_project.codebuild_docker_image"]

  //  filter_group {
  //    filter = "${var.filters}"
  //  }
}

resource "github_repository_webhook" "pipepline_github_webhook" {
  active     = true
  events     = "${var.github_events}"
  repository = "${var.github_repo_names}"

  configuration {
    url          = "${aws_codebuild_webhook.pipeline_webhook.payload_url}"
    secret       = "${data.aws_kms_secrets.github_tokens.plaintext["github_oauth_token"]}"
    content_type = "json"
    insecure_ssl = false
  }

  lifecycle {
    # This is required for idempotency
    ignore_changes = ["configuration.secret"]
  }

  depends_on = ["aws_codebuild_project.codebuild_docker_image"]
}

//
//resource "aws_codepipeline_webhook" "default" {
//  name            = "${aws_codepipeline.codepipeline.name}"
//  authentication  = "${var.webhook_authentication}"
//  target_action   = "${var.webhook_target_action}"
//  target_pipeline = "${aws_codepipeline.codepipeline.name}"
//
//  authentication_configuration {
//    secret_token = "${local.dataops_oauth_token}"
//  }
//
//  filter {
//    json_path    = "$.ref"
//    match_equals = "refs/heads/{Branch}"
//  }
//
//  depends_on = [
//    "aws_codepipeline.codepipeline",
//  ]
//}
//

