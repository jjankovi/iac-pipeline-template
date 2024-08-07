
data "aws_s3_object" "buildspec_validate" {
  bucket = var.s3_codebuild_templates_bucket_name
  key    = "builspec_validate.yml"
}