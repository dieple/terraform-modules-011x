provider "github" {
  token        = "${var.github_token}"
  organization = "${var.github_organization}"
}

resource "github_repository_webhook" "default" {
  count = "${var.enabled == "true" && length(var.github_repositories) > 0 ? length(var.github_repositories) : 0}"

  repository = "${var.github_repositories[count.index]}"
  active     = "${var.active}"

  configuration {
    url          = "${var.webhook_url}"
    content_type = "${var.webhook_content_type}"
    secret       = "${var.webhook_secret}"
    insecure_ssl = "${var.webhook_insecure_ssl}"
  }

  //  events = "${var.events}"
  events = ["push", "pull_request"]

  lifecycle {
    # This is required for idempotency
    ignore_changes = ["configuration.secret"]
  }
}

//resource "aws_codebuild_webhook" "app_prs" {
//  count = "${var.enabled == "true" && length(var.github_repositories) > 0 ? length(var.github_repositories) : 0}"
//
//  project_name = "${var.project_name}"
//
//  filter_group {
//    filter {
//      type    = "EVENT"
//      pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED"
//    }
//
//    filter {
//      type    = "BASE_REF"
//      pattern = "^refs/heads/master$"
//    }
//
//    filter {
//      type    = "HEAD_REF"
//      pattern = "^refs/heads/.*"
//    }
//  }
//}

