# =================================================================
# SNS (slack notification)
# =================================================================
resource "aws_sns_topic" "notifications" {
  name                        = "fanout-notifications"
  fifo_topic                  = false
  content_based_deduplication = false
}

# SNS -> SQS subscription
resource "aws_sns_topic_subscription" "slack_sub" {
  topic_arn              = aws_sns_topic.notifications.arn
  protocol               = "sqs"
  endpoint               = data.terraform_remote_state.sqs.outputs.slack_sqs.arn
  endpoint_auto_confirms = true

  # NOTE: raw_message_delivery を true にすることで、JSONによるラップを行わず、投稿したメッセージをそのまま送信することができる。※consumer 側でメタ情報等が必要な場合は false にする。
  # DOC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#:~:text=raw_message_delivery%20%2D%20(Optional)%20Whether%20to%20enable%20raw%20message%20delivery%20(the%20original%20message%20is%20directly%20passed%2C%20not%20wrapped%20in%20JSON%20with%20the%20original%20message%20in%20the%20message%20property).%20Default%20is%20false.
  raw_message_delivery   = true
}

# NOTE: SQSにSNSからの送信を許可（SQS側に定義したいがお互いにリソースを参照することで循環参照してしまうため、SNS側に定義）
data "aws_iam_policy_document" "slack_sqs_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [data.terraform_remote_state.sqs.outputs.slack_sqs.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.notifications.arn]
    }
  }
}

# =================================================================
# SNS (line message notification)
# =================================================================
resource "aws_sqs_queue_policy" "slack_policy" {
  queue_url = data.terraform_remote_state.sqs.outputs.slack_sqs.id
  policy    = data.aws_iam_policy_document.slack_sqs_policy_doc.json
}

# SNS -> SQS subscription
resource "aws_sns_topic_subscription" "line_sub" {
  topic_arn              = aws_sns_topic.notifications.arn
  protocol               = "sqs"
  endpoint               = data.terraform_remote_state.sqs.outputs.line_message_sqs.arn
  endpoint_auto_confirms = true

  # NOTE: raw_message_delivery を true にすることで、JSONによるラップを行わず、投稿したメッセージをそのまま送信することができる。※consumer 側でメタ情報等が必要な場合は false にする。
  # DOC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#:~:text=raw_message_delivery%20%2D%20(Optional)%20Whether%20to%20enable%20raw%20message%20delivery%20(the%20original%20message%20is%20directly%20passed%2C%20not%20wrapped%20in%20JSON%20with%20the%20original%20message%20in%20the%20message%20property).%20Default%20is%20false.
  raw_message_delivery   = true
}

# NOTE: SQSにSNSからの送信を許可（SQS側に定義したいがお互いにリソースを参照することで循環参照してしまうため、SNS側に定義）
data "aws_iam_policy_document" "line_sqs_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [data.terraform_remote_state.sqs.outputs.line_message_sqs.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.notifications.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "line_policy" {
  queue_url = data.terraform_remote_state.sqs.outputs.line_message_sqs.id
  policy    = data.aws_iam_policy_document.line_sqs_policy_doc.json
}
