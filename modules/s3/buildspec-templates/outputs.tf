
output "bucket" {
  value       = aws_s3_bucket.codebuild_templates_bucket.id
  description = "S3 bucket that stores buildSpec templates"
}