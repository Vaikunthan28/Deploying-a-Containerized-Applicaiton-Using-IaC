# SNS topic that CloudWatch will publish to
resource "aws_sns_topic" "gitlab_ci" {
  name = "${var.cluster_name}-gitlab-ci"
}

# CloudWatch alarm on average EC2 CPU > 70%
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.cluster_name}-HighCPU"
  alarm_description   = "Trigger GitLab scale pipeline when EC2 CPU > 70%"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300       # 5m intervals
  evaluation_periods  = 2
  threshold           = 70
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  # when alarm fires, publish to our SNS topic
  alarm_actions = [ aws_sns_topic.gitlab_ci.arn ]
}

# Subscribe the GitLab trigger URL to that SNS topic
resource "aws_sns_topic_subscription" "gitlab_ci" {
  topic_arn            = aws_sns_topic.gitlab_ci.arn
  protocol             = "https"
  endpoint             = var.trigger_url
  raw_message_delivery = true   # skip the confirmation dance
}
