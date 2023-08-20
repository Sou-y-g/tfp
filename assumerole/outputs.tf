output "access_key_id" {
  description = "The access key ID for the user"
  value       = module.dev-user.user_access_key_id
}

output "secret_access_key" {
  description = "The encrypted secret access key for the user"
  value       = module.dev-user.user_secret_access_key
}
