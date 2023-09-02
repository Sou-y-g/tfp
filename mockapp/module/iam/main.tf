############################################################################
# Lambda => CloudWatch ロール
############################################################################
#ロール作成
resource "aws_iam_role" "hello_lambda_role" {
  name               = "hello_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.hello_lambda_policy.json
}

#assumerole
data "aws_iam_policy_document" "hello_lambda_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

#CloudWatch logsにログを収集するためのポリシー
resource "aws_iam_policy" "log_lambda_policy" {
  name   = "log_lambda_policy"
  policy = data.aws_iam_policy_document.log_lambda_policy.json
}

data "aws_iam_policy_document" "log_lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

#ポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "hello_lambda_role" {
  policy_arn = aws_iam_policy.log_lambda_policy.arn
  role       = aws_iam_role.hello_lambda_role.name
}

# DynamoDBへのアクセス許可ポリシー
resource "aws_iam_policy" "db_access" {
  name = "${var.tag}_dynamodb_access"
  policy = data.aws_iam_policy_document.db_access.json
}

data "aws_iam_policy_document" "db_access" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Scan"
    ]
    resources = [var.db_arn]
  }
}

#ポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "db_access" {
  policy_arn = aws_iam_policy.db_access.arn
  role = aws_iam_role.hello_lambda_role.name
}