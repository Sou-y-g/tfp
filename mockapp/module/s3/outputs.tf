output "s3_domain_name" {
  value = aws_s3_bucket.webhost.bucket_regional_domain_name
}

output "origin_id" {
  value = aws_s3_bucket.webhost.id
}