locals {
  dataops_oauth_token    = "${data.aws_kms_secrets.dataops_oauth_token.plaintext[var.sm_oauth_token_secret_name]}"
  dataops_webhooks_token = "${data.aws_kms_secrets.dataops_webhooks_token.plaintext[var.sm_webhooks_token_secret_name]}"
}

provider "github" {
  version      = "~> 2.2"
  organization = "${var.github_repo_owner}"
  token        = "${data.aws_kms_secrets.github_tokens.plaintext["github_oauth_token"]}"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_kms_secrets" "dataops_oauth_token" {
  secret {
    name    = "${var.sm_oauth_token_secret_name}"
    payload = "${var.github_oauth_token}"
  }
}

data "aws_kms_secrets" "dataops_webhooks_token" {
  secret {
    name    = "${var.sm_webhooks_token_secret_name}"
    payload = "${var.github_webhooks_token}"
  }
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.name}-codepipeline"
  role_arn = "${var.codepipeline_role_arn}"

  artifact_store {
    location = "${var.artifact_store_bucket_name}"
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
        OAuthToken           = "${local.dataops_oauth_token}"
        Owner                = "${var.github_repo_owner}"
        Repo                 = "${var.github_repo_names}"
        Branch               = "${var.github_repo_branch}"
        PollForSourceChanges = "${var.poll_source_changes}"
      }
    }
  }

  stage {
    name = "BuildDockerImage"

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
  name          = "${var.name}-codebuild-project-docker-image"
  description   = "build docker images"
  build_timeout = "300"
  service_role  = "${var.codebuild_service_role_arn}"

  source {
    //    type                = "GITHUB_ENTERPRISE"
    type                = "GITHUB"
    buildspec           = "ci/buildspec.yml"
    location            = "${format("%s/%s/%s.git", var.source_location, var.github_repo_owner, var.github_repo_names)}"
    report_build_status = "${var.report_build_status}"
    git_clone_depth     = 1

    auth = {
      type     = "OAUTH"
      resource = "${local.dataops_oauth_token}"
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  //  cache {
  //    type     = "S3"
  //    location = "${var.artifact_store_bucket_name}"
  //  }

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
        "name"  = "ECR_IMAGE_REPO_NAME"
        "value" = "${signum(length(var.ecr_image_repo_names)) == 1 ? var.ecr_image_repo_names : "UNSET"}"
      },
      {
        "name"  = "ECR_REPO_URI"
        "value" = "${signum(length(var.ecr_image_repo_names)) == 1 ? format("%s.dkr.ecr.%s.amazonaws.com/%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name, var.ecr_image_repo_names) : "UNSET"}"
      },
      {
        "name"  = "ECR_IMAGE_TAG"
        "value" = "${signum(length(var.ecr_image_tag)) == 1 ? var.ecr_image_tag : "latest"}"
      },
      {
        "name"  = "STAGE"
        "value" = "${signum(length(var.stage)) == 1 ? var.stage : "UNSET"}"
      },
      {
        "name"  = "GITHUB_TOKEN"
        "value" = "${signum(length(local.dataops_oauth_token)) == 1 ? local.dataops_oauth_token : "UNSET"}"
      },
      {
        "name"  = "GITHUB_REPO_NAME"
        "value" = "${signum(length(var.github_repo_names)) == 1 ? var.github_repo_names : "UNSET"}"
      },
      {
        "name"  = "GITHUB_REPO_BRANCH"
        "value" = "${signum(length(var.github_repo_branch)) == 1 ? var.github_repo_branch : "UNSET"}"
      },
      {
        "name"  = "EKS_CLUSTER_NAME"
        "value" = "${signum(length(var.eks_cluster_name)) == 1 ? var.eks_cluster_name : "UNSET"}"
      },
      {
        "name"  = "EKS_KUBECTL_ROLE_ARN"
        "value" = "${signum(length(var.eks_kubectl_role_arn)) == 1 ? var.eks_kubectl_role_arn : "UNSET"}"
      },
      {
        "name"  = "KMS_KEY_ARN"
        "value" = "${signum(length(var.kms_key_arn)) == 1 ? var.kms_key_arn : "UNSET"}"
      },
    ]
  //}
  //source {
  //  type                = "GITHUB"
  //  buildspec           = "ci/buildspec.yml"
  //  location            = "${format("%s/%s/%s.git", var.source_location, var.github_repo_owner, var.github_repo_names)}"
  //  report_build_status = "${var.report_build_status}"
  //  git_clone_depth     = 1

  //  auth = {
  //    type     = "OAUTH"
  //    resource = "${local.dataops_oauth_token}"
  //  }
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

  //  tags = "${var.tags}"
}
