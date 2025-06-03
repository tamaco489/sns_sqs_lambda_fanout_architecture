# SNS Topic
resource "aws_sns_topic" "notifications" {
  name                        = "fanout-notifications"
  fifo_topic                  = false
  content_based_deduplication = false
}

# TODO: sqsのリソースは別ディレクトリに切り出す
# SNS -> SQS subscription
resource "aws_sns_topic_subscription" "slack_sub" {
  topic_arn              = aws_sns_topic.notifications.arn
  protocol               = "sqs"
  endpoint               = aws_sqs_queue.slack.arn
  endpoint_auto_confirms = false
  raw_message_delivery   = true
}

resource "aws_sns_topic_subscription" "line_sub" {
  topic_arn              = aws_sns_topic.notifications.arn
  protocol               = "sqs"
  endpoint               = aws_sqs_queue.line_message.arn
  endpoint_auto_confirms = false
  raw_message_delivery   = true
}

# NOTE: raw_message_delivery を true にすることで、JSONによるラップを行わず、投稿したメッセージをそのまま送信することができる。※consumer 側でメタ情報等が必要な場合は false にする。

# SQSにSNSからの送信を許可
data "aws_iam_policy_document" "slack_sqs_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.slack.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.notifications.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "slack_policy" {
  queue_url = aws_sqs_queue.slack.id
  policy    = data.aws_iam_policy_document.slack_sqs_policy_doc.json
}


data "aws_iam_policy_document" "line_sqs_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.line_message.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.notifications.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "line_policy" {
  queue_url = aws_sqs_queue.line_message.id
  policy    = data.aws_iam_policy_document.line_sqs_policy_doc.json
}
