output "slack_sqs" {
  value = {
    arn = aws_sqs_queue.slack.arn
    id  = aws_sqs_queue.slack.id
    name = aws_sqs_queue.slack.name
  }
  description = "SQS queue information for Slack notifications"
}

output "line_message_sqs" {
  value = {
    arn = aws_sqs_queue.line_message.arn
    id  = aws_sqs_queue.line_message.id
    name = aws_sqs_queue.line_message.name
  }
  description = "SQS queue information for LINE message notifications"
}
