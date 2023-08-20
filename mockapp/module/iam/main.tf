#認証用ロール
resource "aws_iam_role" "auth_user_role" {
  name = "${var.tag}_auth_user_role"
  assume_role_policy = data.aws_iam_policy_document.auth_user_assume_role.json
}

data "aws_iam_policy_document" "auth_user_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
  }
}

#未認証用ロール
resource "aws_iam_role" "unauth_user_role" {
  name = "${var.tag}_unauth_user_role"
  assume_role_policy = data.aws_iam_policy_document.unauth_user_assume_role.json
}

data "aws_iam_policy_document" "unauth_user_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["unauthenticated"]
    }
  }
}