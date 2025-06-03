resource "aws_lambda_function" "slack_message_batch" {
  function_name = "${local.fqn}-batch"
  description   = "Slack Message Batch"
  role          = aws_iam_role.slack_message_batch.arn
  package_type  = "Image"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.slack_message_batch.url}:slack_message_batch_v0.0.0"
  timeout       = 10
  memory_size   = 128

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.slack_message_batch.id]
    subnet_ids                  = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
    # subnet_ids                = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids # NOTE: NAT使いたくないのでプライベートサブネットは使わない
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      SERVICE_NAME = "slack-message-batch"
      ENV          = "stg"
    }
  }

  tags = { Name = "${local.fqn}-batch" }
}

# Lambdaのイベントソースマッピングの設定
# SQSキューからのメッセージ受信をトリガーに、Lambadaを起動するために必要な設定
resource "aws_lambda_event_source_mapping" "slack_message_batch" {
  event_source_arn = data.terraform_remote_state.sqs.outputs.slack_message_sqs.arn
  function_name    = aws_lambda_function.slack_message_batch.arn
  enabled          = true
  batch_size       = 1
}
