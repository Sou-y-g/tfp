output "cf_distribution_arn" {
  value = aws_cloudfront_distribution.static.arn
}

output "cf_dns_name" {
  value = aws_cloudfront_distribution.static.domain_name
}

output "cf_zone_id" {
  value = aws_cloudfront_distribution.static.hosted_zone_id
}