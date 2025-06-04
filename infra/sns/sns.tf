# =================================================================
# SNS (slack message notification)
# =================================================================
resource "aws_sns_topic" "fanout_notifications" {
  name                        = "${var.env}-fanout-notifications"
  fifo_topic                  = false
  content_based_deduplication = false
}

resource "aws_sns_topic_subscription" "slack_message" {
  topic_arn              = aws_sns_topic.fanout_notifications.arn
  protocol               = "sqs"
  endpoint               = data.terraform_remote_state.sqs.outputs.slack_message_lambda_process_standard_sqs.arn
  endpoint_auto_confirms = true

  # NOTE: raw_message_delivery を true にすることで、JSONによるラップを行わず、投稿したメッセージをそのまま送信することができる。※consumer 側でメタ情報等が必要な場合は false にする。
  # DOC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#:~:text=raw_message_delivery%20%2D%20(Optional)%20Whether%20to%20enable%20raw%20message%20delivery%20(the%20original%20message%20is%20directly%20passed%2C%20not%20wrapped%20in%20JSON%20with%20the%20original%20message%20in%20the%20message%20property).%20Default%20is%20false.
  raw_message_delivery = true

  # NOTE: メッセージフィルタリングを行うことで、特定のメッセージのみを送信することができる。
  # DOC: https://docs.aws.amazon.com/sns/latest/dg/sns-message-filtering.html
  filter_policy = jsonencode({
    type = ["slack_message"]
  })

  # NOTE: SNS subscription -> SQS のメッセージ送信に失敗した場合、DLQにメッセージを送信する。
  # DOC: https://docs.aws.amazon.com/sns/latest/dg/sns-dead-letter-queues.html#how-messages-moved-into-dead-letter-queue
  redrive_policy = jsonencode({
    deadLetterTargetArn = data.terraform_remote_state.sqs.outputs.slack_message_sns_subscription_dlq.arn
  })
}

# NOTE: SQSにSNSからの送信を許可（SQS側に定義したいがお互いにリソースを参照することで循環参照してしまうため、SNS側に定義）
data "aws_iam_policy_document" "slack_message_sqs_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [data.terraform_remote_state.sqs.outputs.slack_message_lambda_process_standard_sqs.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.fanout_notifications.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "slack_message_policy" {
  queue_url = data.terraform_remote_state.sqs.outputs.slack_message_lambda_process_standard_sqs.id
  policy    = data.aws_iam_policy_document.slack_message_sqs_policy_doc.json
}

# =================================================================
# SNS (line message notification)
# =================================================================
resource "aws_sns_topic_subscription" "line_message" {
  topic_arn              = aws_sns_topic.fanout_notifications.arn
  protocol               = "sqs"
  endpoint               = data.terraform_remote_state.sqs.outputs.line_message_lambda_process_standard_sqs.arn
  endpoint_auto_confirms = true

  # NOTE: raw_message_delivery を true にすることで、JSONによるラップを行わず、投稿したメッセージをそのまま送信することができる。※consumer 側でメタ情報等が必要な場合は false にする。
  # DOC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#:~:text=raw_message_delivery%20%2D%20(Optional)%20Whether%20to%20enable%20raw%20message%20delivery%20(the%20original%20message%20is%20directly%20passed%2C%20not%20wrapped%20in%20JSON%20with%20the%20original%20message%20in%20the%20message%20property).%20Default%20is%20false.
  raw_message_delivery = true

  # NOTE: メッセージフィルタリングを行うことで、特定のメッセージのみを送信することができる。
  # DOC: https://docs.aws.amazon.com/sns/latest/dg/sns-message-filtering.html
  filter_policy = jsonencode({
    type = ["line_message"]
  })

  # NOTE: SNS subscription -> SQS のメッセージ送信に失敗した場合、DLQにメッセージを送信する。
  # DOC: https://docs.aws.amazon.com/sns/latest/dg/sns-dead-letter-queues.html#how-messages-moved-into-dead-letter-queue
  redrive_policy = jsonencode({
    deadLetterTargetArn = data.terraform_remote_state.sqs.outputs.line_message_sns_subscription_dlq.arn
  })
}

# NOTE: SQSにSNSからの送信を許可（SQS側に定義したいがお互いにリソースを参照することで循環参照してしまうため、SNS側に定義）
data "aws_iam_policy_document" "line_message_sqs_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [data.terraform_remote_state.sqs.outputs.line_message_lambda_process_standard_sqs.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.fanout_notifications.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "line_message_policy" {
  queue_url = data.terraform_remote_state.sqs.outputs.line_message_lambda_process_standard_sqs.id
  policy    = data.aws_iam_policy_document.line_message_sqs_policy_doc.json
}
