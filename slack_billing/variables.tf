variable "region" {
  description = "The region where to deploy the infrastructure"
  type        = string
  default     = "ap-northeast-1"
}

variable "tag" {
  description = "Prefix for the tags"
  default     = "slack_billing"
}

variable "slack_webhook_url" {
  description = "Slack webhook URL"
  type = string
  sensitive = true
}

variable "function_file_name" {
  description = "function file name"
  type = string
  default = "lambda_function"
}