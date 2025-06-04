resource "aws_sqs_queue" "slack_message" {
  name                        = "slack-message-sqs"
  fifo_queue                  = false
  content_based_deduplication = false

  # キュー内の全メッセージの配送を遅延させる時間、秒単位で設定。（30秒で設定した場合、キューに送信してもLambda30秒間はこのキューを見ることができない。※0の場合は即時配信となる）
  delay_seconds = 0

  # 最大メッセージサイズ
  max_message_size = 256 * 1024 # 256KB

  # メッセージの保持期間
  message_retention_seconds = 1 * 24 * 60 * 60 # 1日間

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = 15 # NOTE: 本番運用時はもう少し長めにしても良い

  # ロングポーリングの待機時間。秒単位で設定。（0の場合、即時レスポンスとなる）
  receive_wait_time_seconds = 0

  # SQSマネージドサーバーサイド暗号化（SSE）を有効にするかどうか。
  sqs_managed_sse_enabled = false

  # DLQ、及びメッセージの再試行回数を設定
  # DOC: https://docs.aws.amazon.com/sns/latest/dg/sns-dead-letter-queues.html#how-messages-moved-into-dead-letter-queue
  # redrive_policy = jsonencode({
  #   # DLQのARNを指定
  #   deadLetterTargetArn = ""

  #   # リトライ回数の設定。メッセージが繰り返し処理に失敗する場合に無限ループを防ぐ。
  #   maxReceiveCount     = 3
  # })

  tags = { Name = "slack-message-sqs" }
}

resource "aws_sqs_queue" "line_message" {
  name                        = "line-message-sqs"
  fifo_queue                  = false
  content_based_deduplication = false

  # キュー内の全メッセージの配送を遅延させる時間、秒単位で設定。（30秒で設定した場合、キューに送信してもLambda30秒間はこのキューを見ることができない。※0の場合は即時配信となる）
  delay_seconds = 0

  # 最大メッセージサイズ
  max_message_size = 256 * 1024 # 256KB

  # メッセージの保持期間
  message_retention_seconds = 1 * 24 * 60 * 60 # 1日間

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = 15 # NOTE: 本番運用時はもう少し長めにしても良い

  # ロングポーリングの待機時間。秒単位で設定。（0の場合、即時レスポンスとなる）
  receive_wait_time_seconds = 0

  # SQSマネージドサーバーサイド暗号化（SSE）を有効にするかどうか。
  sqs_managed_sse_enabled = false

  # DLQ、及びメッセージの再試行回数を設定
  # DOC: https://docs.aws.amazon.com/sns/latest/dg/sns-dead-letter-queues.html#how-messages-moved-into-dead-letter-queue
  # redrive_policy = jsonencode({
  #   # DLQのARNを指定
  #   deadLetterTargetArn = ""

  #   # リトライ回数の設定。メッセージが繰り返し処理に失敗する場合に無限ループを防ぐ。
  #   maxReceiveCount     = 3
  # })

  tags = { Name = "line-message-sqs" }
}
