resource "aws_cognito_user_pool" "testapp" {
  name = "testapp-user-pool"

  mfa_configuration = "OFF"

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_domain" "testapp" {
  domain       = "testapplication"
  user_pool_id = aws_cognito_user_pool.testapp.id
}

