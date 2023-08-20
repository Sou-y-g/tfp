output "auth_user_role_arn" {
  value = aws_iam_role.auth_user_role.arn
}

output "unauth_user_role_arn" {
  value = aws_iam_role.unauth_user_role.arn
}