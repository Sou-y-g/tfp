module "lambda" {
  source = "./module/lambda"

  slack_billing_notification_role = module.iam.slack_billing_notification_role
  tag    = var.tag
  slack_webhook_url = var.slack_webhook_url
  function_file_name = var.function_file_name
}

module "iam" {
  source = "./module/iam"
}