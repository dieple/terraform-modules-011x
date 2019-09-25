output "badge_url" {
  value = "${data.terraform_remote_state.codepipeline_umsl.badge_url}"
}

output "artifact_store_bucket" {
  value = "${data.terraform_remote_state.codepipeline_umsl.artifact_store_bucket}"
}
