
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.gfr_ui_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.gfr_ui_bucket.id}"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.s3_oai.id}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["gunfire.pro", "www.gunfire.pro"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.gfr_ui_bucket.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}

resource "aws_cloudfront_origin_access_identity" "s3_oai" {
  comment = "OAI for ${aws_s3_bucket.gfr_ui_bucket.id}"
}


// Route 53 stuff. Note that my domain was purchased with namecheap

resource "aws_route53_record" "cloudfront_www" {
  zone_id = aws_route53_zone.gfr_zone.zone_id
  name    = "gunfire.pro"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}