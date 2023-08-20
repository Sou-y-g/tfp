variable "instance_id" {
  description = "The instance ID to monitor"
  type        = string
}

variable "alarm_actions" {
  description = "A list of ARNs (i.e., SNS topic) to be used as the alarm action"
  type        = list(string)
}
