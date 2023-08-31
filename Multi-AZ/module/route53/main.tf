terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

#######################################################################
# Route53
#######################################################################
data "aws_route53_zone" "main" {
  name = var.domain_name
}

#レコード
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = data.aws_route53_zone.main.name
  type    = "A"

  alias {
    name                   = var.cf_dns_name
    zone_id                = var.cf_zone_id
    evaluate_target_health = true
  }
}

#DNS検証用レコード
resource "aws_route53_record" "record_certificate" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  zone_id = data.aws_route53_zone.main.id
  ttl     = 60
}

#######################################################################
# ACM
#######################################################################
#既存のACMを使用
resource "aws_acm_certificate" "certificate" {
  domain_name = var.domain_name
}

#certificate
#resource "aws_acm_certificate" "certificate" {
#  domain_name = aws_route53_record.record.name
#  subject_alternative_names = ["*.${aws_route53_record.record.name}"]
#  validation_method = "DNS"
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}

#certificate validation
#resource "aws_acm_certificate_validation" "certificate_valication" {
#  certificate_arn = aws_acm_certificate.certificate.arn
#  validation_record_fqdns = flatten([ values(aws_route53_record.record_certificate)[*].fqdn ])
#}