# =================================================================
# basic iam policy
# =================================================================
data "aws_iam_policy_document" "lambda_execution_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "slack_message_batch" {
  name               = "${local.fqn}-batch-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_assume_role.json
  tags               = { Name = "${local.fqn}-batch" }
}

# https://docs.aws.amazon.com/ja_jp/aws-managed-policy/latest/reference/AWSLambdaVPCAccessExecutionRole.html
resource "aws_iam_role_policy_attachment" "slack_message_batch_execution_role" {
  role       = aws_iam_role.slack_message_batch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# =================================================================
# sqs iam policy
# =================================================================
data "aws_iam_policy_document" "slack_message_batch_sqs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      data.terraform_remote_state.sqs.outputs.slack_message_sqs.arn
    ]
  }

  # NOTE: Dead Letter Queue の設定が完了次第、以下設定を有効にする
  # statement {
  #   effect = "Allow"
  #   actions = [
  #     "sqs:SendMessage"
  #   ]
  #   resources = [
  #     data.terraform_remote_state.sqs.outputs.slack_message_dlq.arn
  #   ]
  # }
}

# SQSへのアクセス権を定義するポリシードキュメントをIAM Policyとして定義し、IAM Roleに関連付ける
resource "aws_iam_policy" "slack_message_batch_sqs_policy" {
  name        = "${local.fqn}-batch-sqs-policy"
  description = "policy to allow lambdas to retrieve queued data"
  policy      = data.aws_iam_policy_document.slack_message_batch_sqs_policy.json
}

resource "aws_iam_role_policy_attachment" "slack_message_batch_sqs_role" {
  role       = aws_iam_role.slack_message_batch.name
  policy_arn = aws_iam_policy.slack_message_batch_sqs_policy.arn
}
