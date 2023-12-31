#cloudfrontのディストリビューション作成
resource "aws_cloudfront_distribution" "static" {
  origin {
    domain_name = var.s3_domain_name
    origin_id   = var.origin_id
    #OACの設定
    origin_access_control_id = aws_cloudfront_origin_access_control.static.id
  }

  #カスタムドメイン名
  aliases             = [var.domain_name]
  enabled             = true
  default_root_object = "index.html"

  #キャッシュ設定 defaulなので パスパターンは(*)
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id
    #cache_policyは別途設定
    cache_policy_id        = aws_cloudfront_cache_policy.static_cache_policy.id
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

  #acm設定
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1"
  }

  #errorページ(404)
  custom_error_response {
    error_caching_min_ttl = 30000
    error_code            = 404
    response_code         = 200
    response_page_path    = "/error.html"
  }

  #errorページ(403)
  custom_error_response {
    error_caching_min_ttl = 30000
    error_code            = 403
    response_code         = 200
    response_page_path    = "/error.html"
  }

  #cache policyを作成したのちディストリビューション作成
  depends_on = [aws_cloudfront_cache_policy.static_cache_policy]
}

#OACの設定
resource "aws_cloudfront_origin_access_control" "static" {
  name                              = "${var.tag}-static-cf-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
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
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
} 