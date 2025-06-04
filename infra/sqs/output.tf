# =================================================================
# SQS
# =================================================================
output "slack_message_sqs" {
  value = {
    arn  = aws_sqs_queue.slack_message_sqs.arn
    id   = aws_sqs_queue.slack_message_sqs.id
    name = aws_sqs_queue.slack_message_sqs.name
  }
  description = "SQS queue information for Slack message notifications"
}

output "line_message_sqs" {
  value = {
    arn  = aws_sqs_queue.line_message_sqs.arn
    id   = aws_sqs_queue.line_message_sqs.id
    name = aws_sqs_queue.line_message_sqs.name
  }
  description = "SQS queue information for LINE message notifications"
}

# =================================================================
# DLQ
# =================================================================
output "slack_message_dlq" {
  value = {
    arn  = aws_sqs_queue.slack_message_dlq.arn
    id   = aws_sqs_queue.slack_message_dlq.id
    name = aws_sqs_queue.slack_message_dlq.name
  }
  description = "DLQ queue information for Slack message notifications"
}

output "line_message_dlq" {
  value = {
    arn  = aws_sqs_queue.line_message_dlq.arn
    id   = aws_sqs_queue.line_message_dlq.id
    name = aws_sqs_queue.line_message_dlq.name
  }
  description = "DLQ queue information for LINE message notifications"
}
