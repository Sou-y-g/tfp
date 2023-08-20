# IAMユーザー 'dev-user' を作成
resource "aws_iam_user" "dev-user" {
  name = "dev-user"
}

# アクセスキーを作成
resource "aws_iam_access_key" "dev-key" {
  user = aws_iam_user.dev-user.name
}

# dev-roleの信頼ポリシー。dev-userがこのロールを引き受けられるようにする
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.dev-user.arn]
    }
  }
}

# dev-roleの作成。上で作成した信頼ポリシーを適用する
resource "aws_iam_role" "dev-role" {
  name               = "dev-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# dev-roleのアイデンティティポリシー (S3に対する全ての操作を許可)
data "aws_iam_policy_document" "dev-policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

# dev-roleに対するポリシーを作成
resource "aws_iam_policy" "dev-role-policy" {
  name        = "dev-role-policy"
  description = "policy for dev-role"
  policy      = data.aws_iam_policy_document.dev-policy.json
}

# dev-roleにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.dev-role.name
  policy_arn = aws_iam_policy.dev-role-policy.arn
}
