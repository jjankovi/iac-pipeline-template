
resource "aws_s3_bucket" "codebuild_templates_bucket" {
  bucket_prefix = regex("[a-z0-9.-]+", "codebuild-templates")
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "codebuild_templates_bucket_access" {
  bucket                  = aws_s3_bucket.codebuild_templates_bucket.id
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_versioning" "codebuild_templates_bucket_versioning" {
  bucket = aws_s3_bucket.codebuild_templates_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_encryption" {
  bucket = aws_s3_bucket.codebuild_templates_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_object" "buildspec_validate" {
  bucket = aws_s3_bucket.codebuild_templates_bucket.id
  key    = "builspec_validate.yml"
  source = "./templates/buildspec_validate.yml"
  etag   = filemd5("./templates/buildspec_validate.yml")
}