locals {
  prevent_unencrypted_uploads   = "${var.prevent_unencrypted_uploads == "true" && var.enable_server_side_encryption == "true" ? 1 : 0}"
  policy1                       = "${local.prevent_unencrypted_uploads ? join("", data.aws_iam_policy_document.prevent_unencrypted_uploads.*.json) : ""}"
  policy2                       = "${signum(length(var.allowed_remote_accounts)) == 1  ? join("", data.aws_iam_policy_document.allowed_account_ids.*.json) : ""}"
  terraform_backend_config_file = "${format("%s/%s", var.terraform_backend_config_file_path, var.terraform_backend_config_file_name)}"
}

data "aws_caller_identity" "current" {}

module "s3_bucket_label" {
  source      = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-terraform-label"
  namespace   = "${var.namespace}"
  stage       = "${var.stage}"
  name        = "${var.name}"
  delimiter   = "${var.delimiter}"
  attributes  = "${var.attributes}"
  project     = "${var.project}"
  cost_centre = "${var.cost_centre}"
  tags        = "${var.tags}"
}

data "aws_iam_policy_document" "allowed_account_ids" {
  count = "${signum(length(var.allowed_remote_accounts)) == 1 ? 1 : 0}"

  statement = {
    sid = "AllowOtherAccountAccess"

    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "${formatlist("arn:aws:iam::%s:root", var.allowed_remote_accounts)}",
      ]
    }

    actions = [
      "s3:PutObject",
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::${module.s3_bucket_label.id}/*",
      "arn:aws:s3:::${module.s3_bucket_label.id}",
    ]
  }
}

data "aws_iam_policy_document" "prevent_unencrypted_uploads" {
  count = "${local.prevent_unencrypted_uploads}"

  statement = {
    sid = "DenyIncorrectEncryptionHeader"

    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${module.s3_bucket_label.id}/*",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "AES256",
      ]
    }
  }

  statement = {
    sid = "DenyUnEncryptedObjectUploads"

    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${module.s3_bucket_label.id}/*",
    ]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "true",
      ]
    }
  }
}

module "aggregated_policy" {
  source = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-aws-iam-policy-document-aggregator"

  source_documents = [
    "${local.policy1}",
    "${local.policy2}",
  ]
}

resource "aws_s3_bucket" "default" {
  bucket        = "${module.s3_bucket_label.id}"
  acl           = "${var.acl}"
  region        = "${var.region}"
  force_destroy = "${var.force_destroy}"
  policy        = "${local.prevent_unencrypted_uploads == 1 && signum(length(var.allowed_remote_accounts)) == 1 ? "${module.aggregated_policy.result_document}" : ""}"

  versioning {
    enabled    = true
    mfa_delete = "${var.mfa_delete}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = "${module.s3_bucket_label.tags}"
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = "${aws_s3_bucket.default.id}"
  block_public_acls       = "${var.block_public_acls}"
  ignore_public_acls      = "${var.ignore_public_acls}"
  block_public_policy     = "${var.block_public_policy}"
  restrict_public_buckets = "${var.restrict_public_buckets}"
}

module "dynamodb_table_label" {
  source      = "git::ssh://git@github.com/dieple/terraform-modules-011x.git//terraform-terraform-label"
  namespace   = "${var.namespace}"
  stage       = "${var.stage}"
  name        = "${var.name}"
  delimiter   = "${var.delimiter}"
  attributes  = ["${compact(concat(var.attributes, list("lock")))}"]
  project     = "${var.project}"
  cost_centre = "${var.cost_centre}"
  tags        = "${var.tags}"
}

resource "aws_dynamodb_table" "with_server_side_encryption" {
  count          = "${var.enable_server_side_encryption == "true" ? 1 : 0}"
  name           = "${module.dynamodb_table_label.id}"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "LockID"

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = "${module.dynamodb_table_label.tags}"
}

resource "aws_dynamodb_table" "without_server_side_encryption" {
  count          = "${var.enable_server_side_encryption == "true" ? 0 : 1}"
  name           = "${module.dynamodb_table_label.id}"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "LockID"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = "${module.dynamodb_table_label.tags}"
}

data "template_file" "terraform_backend_config" {
  template = "${file("${path.module}/templates/terraform.tf.tpl")}"

  vars {
    region               = "${var.region}"
    bucket               = "${aws_s3_bucket.default.id}"
    dynamodb_table       = "${element(coalescelist(aws_dynamodb_table.with_server_side_encryption.*.name, aws_dynamodb_table.without_server_side_encryption.*.name), 0)}"
    encrypt              = "${var.enable_server_side_encryption == "true" ? "true" : "false"}"
    role_arn             = "${var.role_arn}"
    profile              = "${var.profile}"
    terraform_version    = "${var.terraform_version}"
    terraform_state_file = "${var.terraform_state_file}"
  }
}

resource "local_file" "terraform_backend_config" {
  count    = "${length(var.terraform_backend_config_file_path) > 0 ? 1 : 0}"
  content  = "${data.template_file.terraform_backend_config.rendered}"
  filename = "${local.terraform_backend_config_file}"
}
