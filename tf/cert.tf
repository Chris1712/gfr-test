// THe cert needs to be created in us-east-1 in order to be used with cloudfront
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.us-east-1
  domain_name       = "gunfire.pro"
  validation_method = "DNS"

  subject_alternative_names = ["www.gunfire.pro"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  provider          = aws.us-east-1

  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.gfr_zone.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
}

resource "aws_route53_zone" "gfr_zone" {
  name = "gunfire.pro"
}