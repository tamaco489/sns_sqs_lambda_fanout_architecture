# =================================================================
# SQS -> DLQ
# =================================================================
resource "aws_sqs_queue" "slack_message_lambda_process_dlq" {
  name                        = "${var.env}-slack-message-lambda-process-dlq"
  fifo_queue                  = false
  content_based_deduplication = false

  # キュー内の全メッセージの配送を遅延させる時間。秒単位で設定。（30秒で設定した場合、キューに送信してもLambda30秒間はこのキューを見ることができない。※0の場合は即時配信となる）
  delay_seconds = 0

  # 最大メッセージサイズ
  max_message_size = 256 * 1024 # 256KB

  # メッセージの保持期間
  message_retention_seconds = 2 * 24 * 60 * 60 # 2日間

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = 30 # NOTE: 本番運用時はもう少し長めにしても良い

  # ロングポーリングの待機時間。秒単位で設定。（0の場合、即時レスポンスとなる）
  receive_wait_time_seconds = 0

  # SQSマネージドサーバーサイド暗号化（SSE）を有効にするかどうか。
  sqs_managed_sse_enabled = false

  tags = { Name = "${var.env}-slack-message-lambda-process-dlq" }
}

resource "aws_sqs_queue" "line_message_lambda_process_dlq" {
  name                        = "${var.env}-line-message-lambda-process-dlq"
  fifo_queue                  = false
  content_based_deduplication = false

  # キュー内の全メッセージの配送を遅延させる時間。秒単位で設定。（30秒で設定した場合、キューに送信しても30秒間はこのキューを見ることができない。※0の場合は即時配信となる）
  delay_seconds = 0

  # 最大メッセージサイズ
  max_message_size = 256 * 1024 # 256KB

  # メッセージの保持期間
  message_retention_seconds = 2 * 24 * 60 * 60 # 2日間

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = 30 # NOTE: 本番運用時はもう少し長めにしても良い

  # ロングポーリングの待機時間。秒単位で設定。（0の場合、即時レスポンスとなる）
  receive_wait_time_seconds = 0

  # SQSマネージドサーバーサイド暗号化（SSE）を有効にするかどうか。
  sqs_managed_sse_enabled = false

  tags = { Name = "${var.env}-line-message-lambda-process-dlq" }
}

# =================================================================
# SNS subscription -> DLQ
# =================================================================
resource "aws_sqs_queue" "slack_message_sns_subscription_dlq" {
  name                        = "${var.env}-slack-message-sns-subscription-dlq"
  fifo_queue                  = false
  content_based_deduplication = false

  # キュー内の全メッセージの配送を遅延させる時間。秒単位で設定。（30秒で設定した場合、キューに送信しても30秒間はこのキューを見ることができない。※0の場合は即時配信となる）
  delay_seconds = 0

  # 最大メッセージサイズ
  max_message_size = 256 * 1024 # 256KB

  # メッセージの保持期間
  message_retention_seconds = 2 * 24 * 60 * 60 # 2日間

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = 30 # NOTE: 本番運用時はもう少し長めにしても良い

  # ロングポーリングの待機時間。秒単位で設定。（0の場合、即時レスポンスとなる）
  receive_wait_time_seconds = 0

  # SQSマネージドサーバーサイド暗号化（SSE）を有効にするかどうか。
  sqs_managed_sse_enabled = false

  tags = { Name = "${var.env}-slack-message-sns-subscription-dlq" }
}

resource "aws_sqs_queue" "line_message_sns_subscription_dlq" {
  name                        = "${var.env}-line-message-sns-subscription-dlq"
  fifo_queue                  = false
  content_based_deduplication = false

  # キュー内の全メッセージの配送を遅延させる時間。秒単位で設定。（30秒で設定した場合、キューに送信してもLambda30秒間はこのキューを見ることができない。※0の場合は即時配信となる）
  delay_seconds = 0

  # 最大メッセージサイズ
  max_message_size = 256 * 1024 # 256KB

  # メッセージの保持期間
  message_retention_seconds = 2 * 24 * 60 * 60 # 2日間

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = 30 # NOTE: 本番運用時はもう少し長めにしても良い

  # ロングポーリングの待機時間。秒単位で設定。（0の場合、即時レスポンスとなる）
  receive_wait_time_seconds = 0

  # SQSマネージドサーバーサイド暗号化（SSE）を有効にするかどうか。
  sqs_managed_sse_enabled = false

  tags = { Name = "${var.env}-line-message-sns-subscription-dlq" }
}
