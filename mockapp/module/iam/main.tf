#lambda用のロール作成
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