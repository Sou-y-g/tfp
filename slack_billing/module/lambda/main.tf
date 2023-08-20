data "archive_file" "func_file" {
  type = "zip"
  #source_file = "../src/lambda_function.py"
  #output_path = "../src/lambda_function.zip"
  source_file = "module/lambda/src/hello.py"
  output_path = "module/lambda/src/hello.zip"
}

resource "aws_lambda_function" "slack_billing_notification_func" {
  filename = "hello.zip"
  #filename         = "${data.archive_file.sample_function.output_path}"
  function_name = "slack_billing_notification"
  role = var.slack_billing_notification_role
  handler = "hello.lambda_handler"
  runtime = "python3.10"

  environment {
    variables = {
        SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

#event bridge rule
resource "aws_cloudwatch_event_rule" "billing_event" {
  name = "aws-billing-notification"
  schedule_expression = "cron(0 1 * * ? *)"
}

#Event bridge target
#resource "aws_cloudwatch_event_target" "name" {
#  rule = aws_cloudwatch_event_rule.billing_event.name
#  target_id = "AWSBillingNotification"
#  arn = aws_lambda_function.slack_billing_notification_func.arn
#
#  depends_on = [aws_lambda_function.slack_billing_notification_func]
#}