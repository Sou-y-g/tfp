resource "aws_s3_bucket" "backet" {
  bucket = "${var.tag}-install-package"

  #バケット内が空じゃなくても削除
  force_destroy = true
}

#ACL無効
resource "aws_s3_bucket_ownership_controls" "backet" {
  bucket = aws_s3_bucket.backet.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#パブリックブロックアクセス無効(有効の場合はtrue)
resource "aws_s3_bucket_public_access_block" "backet" {
  bucket                  = aws_s3_bucket.backet.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#バケットポリシー
resource "aws_s3_bucket_policy" "backet" {
  bucket     = aws_s3_bucket.backet.id
  policy     = data.aws_iam_policy_document.backet.json
  depends_on = [aws_s3_bucket_public_access_block.backet]
}

data "aws_iam_policy_document" "backet" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.backet.arn}/*"]
  }
}