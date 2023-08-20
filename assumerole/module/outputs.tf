output "user_access_key_id" {
  description = "The access key ID for the user"
  value       = aws_iam_access_key.dev-key.id
}

output "user_secret_access_key" {
  description = "The encrypted secret access key for the user"
  value       = aws_iam_access_key.dev-key.encrypted_secret
}
