resource "aws_s3_bucket" "webhost" {
  bucket = "${var.tag}-website-hosting"

  #バケット内が空じゃなくても削除
  force_destroy = true
}

#ACL無効
resource "aws_s3_bucket_ownership_controls" "webhost" {
  bucket = aws_s3_bucket.webhost.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#パブリックブロックアクセス無効(有効の場合はtrue)
resource "aws_s3_bucket_public_access_block" "webhost" {
  bucket = aws_s3_bucket.webhost.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

#バージョニング 無効
resource "aws_s3_bucket_versioning" "webhost" {
  bucket = aws_s3_bucket.webhost.id
  versioning_configuration {
    status = "Enabled"
  }
}

#暗号化 デフォルト
resource "aws_s3_bucket_server_side_encryption_configuration" "webhost" {
  bucket = aws_s3_bucket.webhost.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#バケットポリシー
resource "aws_s3_bucket_policy" "webhost" {
  bucket = aws_s3_bucket.webhost.id
  policy = data.aws_iam_policy_document.webhost.json
  depends_on = [aws_s3_bucket_public_access_block.webhost]
}

data "aws_iam_policy_document" "webhost" {
  statement {
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.webhost.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [var.cf_distribution_arn]
    }

  }
}

#静的Webサイトホスティング
resource "aws_s3_bucket_website_configuration" "webhost" {
  bucket = aws_s3_bucket.webhost.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
