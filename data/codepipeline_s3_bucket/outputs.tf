output "access_key_id" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.access_key_id}"
}

output "bucket_arn" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.bucket_arn}"
}

output "bucket_domain_name" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.bucket_domain_name}"
}

output "bucket_id" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.bucket_id}"
}

output "secret_access_key" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.secret_access_key}"
}

output "user_arn" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.user_arn}"
}

output "user_enabled" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.user_enabled}"
}

output "user_name" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.user_name}"
}

output "user_unique_id" {
  value = "${data.terraform_remote_state.codepipeline_s3_bucket.user_unique_id}"
}
