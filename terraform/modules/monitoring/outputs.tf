output "sns_topic_arn" {
  description = "SNS topic ARN for GitLab CI triggers"
  value       = aws_sns_topic.gitlab_ci.arn
}
output "alarm_name" {
  description = "Name of the CPU alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}