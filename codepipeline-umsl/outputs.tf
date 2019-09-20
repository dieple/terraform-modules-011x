output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"

  //  value       = "${var.badge_url}"
  value = "${join("", aws_codebuild_project.codebuild_docker_image.*.badge_url)}"
}

output "artifact_store_bucket" {
  value = "${aws_s3_bucket.default.id}"
}

//
//output "webhook_id" {
//  description = "The CodePipeline webhook's ARN."
//  value       = "${join("", aws_codepipeline_webhook.webhook.*.id)}"
//}
//
//output "webhook_url" {
//  description = "The CodePipeline webhook's URL. POST events to this endpoint to trigger the target"
//  value       = "${local.webhook_url}"
//  sensitive   = true
//}

