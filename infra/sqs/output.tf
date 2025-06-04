# =================================================================
# Standard SQS
# =================================================================
output "slack_message_lambda_process_standard_sqs" {
  value = {
    arn  = aws_sqs_queue.slack_message_lambda_process_standard_sqs.arn
    id   = aws_sqs_queue.slack_message_lambda_process_standard_sqs.id
    name = aws_sqs_queue.slack_message_lambda_process_standard_sqs.name
  }
  description = "Slack message standard SQS"
}

output "line_message_lambda_process_standard_sqs" {
  value = {
    arn  = aws_sqs_queue.line_message_lambda_process_standard_sqs.arn
    id   = aws_sqs_queue.line_message_lambda_process_standard_sqs.id
    name = aws_sqs_queue.line_message_lambda_process_standard_sqs.name
  }
  description = "LINE message standard SQS"
}

# =================================================================
# SQS -> DLQ
# =================================================================
output "slack_message_lambda_process_dlq" {
  value = {
    arn  = aws_sqs_queue.slack_message_lambda_process_dlq.arn
    id   = aws_sqs_queue.slack_message_lambda_process_dlq.id
    name = aws_sqs_queue.slack_message_lambda_process_dlq.name
  }
  description = "Slack message Lambda processing DLQ"
}

output "line_message_lambda_process_dlq" {
  value = {
    arn  = aws_sqs_queue.line_message_lambda_process_dlq.arn
    id   = aws_sqs_queue.line_message_lambda_process_dlq.id
    name = aws_sqs_queue.line_message_lambda_process_dlq.name
  }
  description = "LINE message Lambda processing DLQ"
}

# =================================================================
# SNS subscription -> DLQ
# =================================================================
output "slack_message_sns_subscription_dlq" {
  value = {
    arn  = aws_sqs_queue.slack_message_sns_subscription_dlq.arn
    id   = aws_sqs_queue.slack_message_sns_subscription_dlq.id
    name = aws_sqs_queue.slack_message_sns_subscription_dlq.name
  }
  description = "Slack message SNS subscription DLQ"
}

output "line_message_sns_subscription_dlq" {
  value = {
    arn  = aws_sqs_queue.line_message_sns_subscription_dlq.arn
    id   = aws_sqs_queue.line_message_sns_subscription_dlq.id
    name = aws_sqs_queue.line_message_sns_subscription_dlq.name
  }
  description = "LINE message SNS subscription DLQ"
}
