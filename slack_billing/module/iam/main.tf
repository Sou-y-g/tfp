#lambda用のロール作成
resource "aws_iam_role" "slack_billing_notification_role" {
  name               = "slack_billing_notification_role"
  assume_role_policy = data.aws_iam_policy_document.slack_billing_notification_assume_policy.json
}

#assumerole
data "aws_iam_policy_document" "slack_billing_notification_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

#CloudWatch logsにログを収集するためのポリシー
resource "aws_iam_policy" "slack_billing_notification_policy" {
  name   = "slack_billing_notification_policy"
  policy = data.aws_iam_policy_document.slack_billing_notification_policy.json
}

data "aws_iam_policy_document" "slack_billing_notification_policy" {
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
resource "aws_iam_role_policy_attachment" "slack_billing_notification_role" {
  policy_arn = aws_iam_policy.slack_billing_notification_policy.arn
  role       = aws_iam_role.slack_billing_notification_role.name
}