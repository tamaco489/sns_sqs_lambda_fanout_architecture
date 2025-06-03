resource "aws_sqs_queue" "slack" {
  name                        = "slack-sqs"
  fifo_queue                  = false
  content_based_deduplication = false
  delay_seconds               = 0
  max_message_size            = 256 * 1024  # 256KB
  message_retention_seconds   = 1 * 24 * 60 * 60  # 1日間
  visibility_timeout_seconds  = 10 // NOTE: 本番運用時はもう少し長めにしても良い
  receive_wait_time_seconds   = 0

  tags = { Name = "slack-sqs" }
}

resource "aws_sqs_queue" "line_message" {
  name                        = "line-message-sqs"
  fifo_queue                  = false
  content_based_deduplication = false
  delay_seconds               = 0
  max_message_size            = 256 * 1024  # 256KB
  message_retention_seconds   = 1 * 24 * 60 * 60  # 1日間
  visibility_timeout_seconds  = 10 // NOTE: 本番運用時はもう少し長めにしても良い
  receive_wait_time_seconds   = 0

  tags = { Name = "line-message-sqs" }
}
