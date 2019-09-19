locals {
  //  webhook_secret = "${join("", random_string.webhook_secret.*.result)}"
  webhook_url = "${join("", aws_codepipeline_webhook.codepipeline_webhook.*.url)}"
}

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

resource "aws_codebuild_webhook" "cb_webhook_prs" {
  project_name = "${aws_codebuild_project.codebuild_docker_image.name}"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED"
    }

    filter {
      type    = "BASE_REF"
      pattern = "^refs/heads/master$"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "^refs/heads/.*"
    }
  }

  depends_on = [
    "aws_codebuild_project.codebuild_docker_image",
  ]
}

resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  count           = "${local.enabled && var.webhook_enabled == "true" ? 1 : 0}"
  name            = "${module.codepipeline_label.id}"
  authentication  = "${var.webhook_authentication}"
  target_action   = "${var.webhook_target_action}"
  target_pipeline = "${join("", aws_codepipeline.codepipeline.*.name)}"

  authentication_configuration {
    secret_token = "${data.aws_kms_secrets.github_tokens.plaintext["github_oauth_token"]}"
  }

  filter {
    json_path    = "${var.webhook_filter_json_path}"
    match_equals = "${var.webhook_filter_match_equals}"
  }

  //    depends_on = [
  //      "aws_codepipeline.codepipeline.name",
  //    ]
}

resource "github_repository_webhook" "gh_repo_webhook" {
  repository = "${var.github_repo_names}"

  configuration {
    url          = "${local.webhook_url}"
    content_type = "json"
    insecure_ssl = false
    secret       = "${data.aws_kms_secrets.github_tokens.plaintext["github_webhooks_token"]}"
  }

  events = ["${var.github_webhook_events}"]

  //depends_on = [
  //  aws_codepipeline_webhook.pipelines,
  //  ]
}
