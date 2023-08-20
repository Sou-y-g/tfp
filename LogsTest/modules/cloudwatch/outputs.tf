output "cloudwatch_alarm_id" {
  description = "The ID of the created CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.ec2-alarm.id
}

output "cloudwatch_alarm_state" {
  description = "The current state of the CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.ec2-alarm.alarm_actions
}
