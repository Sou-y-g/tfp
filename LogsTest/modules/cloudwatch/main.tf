resource "aws_cloudwatch_metric_alarm" "ec2-alarm" {
  alarm_name          = "ec2-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "This metric checks for high CPU usage"
  alarm_actions       = var.alarm_actions
  dimensions = {
    InstanceId = var.instance_id
  }
}