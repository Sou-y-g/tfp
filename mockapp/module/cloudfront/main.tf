resource "aws_cloudfront_distribution" "static" {
  origin {
    domain_name = var.domain_name
    origin_id   = var.origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  #キャッシュ設定 defaulなので パスパターンは(*)
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id
    #cache_policyは別途設定
    cache_policy_id = aws_cloudfront_cache_policy.static_cache_policy.id
    viewer_protocol_policy = "allow-all"
  }

  #料金クラス(北米のみ)
  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  #cache policyを作成したのちディストリビューション作成
  depends_on = [aws_cloudfront_cache_policy.static_cache_policy]
}

#cache policy
resource "aws_cloudfront_cache_policy" "static_cache_policy" {
  name        = "${var.tag}-static_cache_policy"
  comment     = "not cache"
  default_ttl = 0
  max_ttl     = 1
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_gzip = true
    enable_accept_encoding_brotli = true
  }
} 