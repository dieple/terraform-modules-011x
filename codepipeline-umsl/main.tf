locals {
  enabled             = "${var.enabled == "true" ? true : false}"
  umsl_oauth_token    = "${data.aws_kms_secrets.umsl_oauth_token.plaintext[var.sm_oauth_token_secret_name]}"
  umsl_webhooks_token = "${data.aws_kms_secrets.umsl_webhooks_token.plaintext[var.sm_webhooks_token_secret_name]}"
}

provider "github" {
  version      = "~> 2.2"
  organization = "dieple"
  token        = "${data.aws_kms_secrets.umsl_oauth_token.plaintext["umsl_oauth_token"]}"
}

data "aws_caller_identity" "default" {}

data "aws_region" "default" {}

data "aws_kms_secrets" "umsl_oauth_token" {
  secret {
    name    = "${var.sm_oauth_token_secret_name}"
    payload = "${var.umsl_oauth_token}"
  }
}

data "aws_kms_secrets" "umsl_webhooks_token" {
  secret {
    name    = "${var.sm_webhooks_token_secret_name}"
    payload = "${var.umsl_webhooks_token}"
  }
}

module "codepipeline_label" {
  source     = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-terraform-label"
  attributes = ["${compact(concat(var.attributes, list("codepipeline")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_s3_bucket" "default" {
  count         = "${local.enabled ? 1 : 0}"
  bucket        = "${module.codepipeline_label.id}-${var.github_repo_names}"
  acl           = "private"
  force_destroy = "${var.s3_bucket_force_destroy}"
  tags          = "${module.codepipeline_label.tags}"
}

module "codepipeline_assume_label" {
  source     = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-terraform-label"
  attributes = ["${compact(concat(var.attributes, list("codepipeline", "assume")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

module "codepipeline_s3_policy_label" {
  source     = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-terraform-label"
  attributes = ["${compact(concat(var.attributes, list("codepipeline", "s3")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_iam_policy" "s3" {
  count  = "${local.enabled ? 1 : 0}"
  name   = "${module.codepipeline_s3_policy_label.id}-${var.github_repo_names}"
  policy = "${data.aws_iam_policy_document.s3.json}"
}

module "codebuild_label" {
  source     = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-terraform-label"
  attributes = ["${compact(concat(var.attributes, list("codebuild")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_codepipeline" "codepipeline" {
  count    = "${local.enabled == "true" ? 1 : 0}"
  name     = "${var.github_repo_names}-pipeline"
  role_arn = "${aws_iam_role.iam_codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.default.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["code"]

      configuration {
        OAuthToken           = "${local.umsl_oauth_token}"
        Owner                = "${var.github_repo_owner}"
        Repo                 = "${var.github_repo_names}"
        Branch               = "${var.github_repo_branch}"
        PollForSourceChanges = "${var.poll_source_changes}"
      }
    }
  }

  stage {
    name = "Build-UMSL-App"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["code"]
      version         = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.codebuild_docker_image.name}"
      }
    }
  }

  //  stage {
  //    name = "Deploy"
  //
  //    action {
  //      name            = "Deploy"
  //      category        = "Build"
  //      owner           = "AWS"
  //      provider        = "CodeBuild"
  //      input_artifacts = ["code"]
  //      version         = "1"
  //
  //      configuration {
  //        ProjectName = "${aws_codebuild_project.codebuild_deploy_on_eks.name}"
  //      }
  //
  //    }
  //  }
  depends_on = [
    "aws_codebuild_project.codebuild_docker_image",
  ]
}

resource "aws_codebuild_project" "codebuild_docker_image" {
  count         = "${local.enabled == "true" ? 1 : 0}"
  name          = "${var.github_repo_names}"
  description   = "build docker images"
  build_timeout = "300"
  service_role  = "${aws_iam_role.iam_code_build_role.arn}"

  artifacts {
    type = "CODEPIPELINE"

    //    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "${var.build_compute_type}"
    image           = "${var.build_image}"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable = [
      {
        "name"  = "AWS_REGION"
        "value" = "${data.aws_region.current.name}"
      },
      {
        "name"  = "AWS_ACCOUNT_ID"
        "value" = "${data.aws_caller_identity.current.account_id}"
      },
      {
        //      {
        //        "name"  = "ECR_IMAGE_REPO_NAME"
        //        "value" = "${signum(length(var.ecr_image_repo_names)) == 1 ? var.ecr_image_repo_names : "UNSET"}"
        //      },
        //      {
        //        "name"  = "ECR_REPO_URI"
        //        "value" = "${signum(length(var.ecr_image_repo_names)) == 1 ? format("%s.dkr.ecr.%s.amazonaws.com/%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name, var.ecr_image_repo_names) : "UNSET"}"
        //      },
        "name" = "ECR_IMAGE_TAG"

        "value" = "${signum(length(var.ecr_image_tag)) == 1 ? var.ecr_image_tag : "latest"}"
      },
      {
        "name"  = "STAGE"
        "value" = "${signum(length(var.stage)) == 1 ? var.stage : "UNSET"}"
      },
      {
        "name"  = "GITHUB_TOKEN"
        "value" = "${signum(length(local.umsl_oauth_token)) == 1 ? local.umsl_oauth_token : "UNSET"}"
      },
      {
        "name"  = "GITHUB_REPO_NAME"
        "value" = "${signum(length(var.github_repo_names)) == 1 ? var.github_repo_names : "UNSET"}"
      },
      {
        "name"  = "GITHUB_REPO_BRANCH"
        "value" = "${signum(length(var.github_repo_branch)) == 1 ? var.github_repo_branch : "UNSET"}"
      },
    ]

    //      {
    //        "name"  = "EKS_CLUSTER_NAME"
    //        "value" = "${signum(length(var.eks_cluster_name)) == 1 ? var.eks_cluster_name : "UNSET"}"
    //      },
    //      {
    //        "name"  = "EKS_KUBECTL_ROLE_ARN"
    //        "value" = "${signum(length(var.eks_kubectl_role_arn)) == 1 ? var.eks_kubectl_role_arn : "UNSET"}"
    //      },
  }

  source {
    type                = "CODEPIPELINE"
    buildspec           = "buildspec.yaml"
    location            = "${format("%s/%s/%s.git", var.source_location, var.github_repo_owner, var.github_repo_names)}"
    report_build_status = "${var.report_build_status}"
    git_clone_depth     = 1
  }

  //  vpc_config {
  //    vpc_id = "${var.vpc_id}"
  //
  //    subnets = [
  //      "${var.subnets}"
  //    ]
  //
  //    security_group_ids = [
  //     "${var.security_group_ids}"
  //    ]
  //  }

  tags = "${module.codebuild_label.tags}"
}
