// Public bucket holding UI
resource "aws_s3_bucket" "gfr_ui_bucket" {
  bucket = "gfr-ui"
}

resource "aws_s3_bucket_ownership_controls" "gfr_ui_bucket_acl_ownership" {
  bucket = aws_s3_bucket.gfr_ui_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "gfr_ui_bucket_access" {
  bucket = aws_s3_bucket.gfr_ui_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "gfr_ui_bucket_acl" {
  bucket = aws_s3_bucket.gfr_ui_bucket.id
  acl    = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.gfr_ui_bucket_acl_ownership,
    aws_s3_bucket_public_access_block.gfr_ui_bucket_access,
  ]
}
