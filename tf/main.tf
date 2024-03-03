// Public bucket holding UI
resource "aws_s3_bucket" "gfr_ui_bucket" {
  bucket = "gunfire.pro"
}

resource "aws_s3_bucket_website_configuration" "gfr_ui_bucket_website" {
  bucket = aws_s3_bucket.gfr_ui_bucket.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
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


// Route 53 stuff. Note that my domain was purchased with namecheap

resource "aws_route53_zone" "gfr_zone" {
  name = "gunfire.pro"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.gfr_zone.zone_id
  name    = "gunfire.pro"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.gfr_ui_bucket_website.website_domain
    zone_id                = aws_s3_bucket.gfr_ui_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}
