output "fanout_notifications" {
  value = {
    arn = aws_sns_topic.fanout_notifications.arn
    id  = aws_sns_topic.fanout_notifications.id
    name = aws_sns_topic.fanout_notifications.name
  }
}
