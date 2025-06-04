resource "aws_sqs_queue" "slack_message_dlq" {
  name = "${local.slack_message_dlq}"

  # メッセージの保持期間
  message_retention_seconds = 2 * 24 * 60 * 60 # 2日間

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = 15 # NOTE: 本番運用時はもう少し長めにしても良い

  sqs_managed_sse_enabled = false

  tags = { Name = "${local.slack_message_dlq}" }
}

resource "aws_sqs_queue" "line_message_dlq" {
  name = "${local.line_message_dlq}"

  # メッセージの保持期間
  message_retention_seconds = 2 * 24 * 60 * 60 # 2日間

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = 15 # NOTE: 本番運用時はもう少し長めにしても良い

  sqs_managed_sse_enabled = false

  tags = { Name = "${local.line_message_dlq}" }
}
