resource "aws_lambda_function" "line_message_batch" {
  function_name = "${local.fqn}-batch"
  description   = "Line Message Batch"
  role          = aws_iam_role.line_message_batch.arn
  package_type  = "Image"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.line_message_batch.url}:line_message_batch_v0.0.0"
  timeout       = 10
  memory_size   = 128

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.line_message_batch.id]
    subnet_ids                  = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
    # subnet_ids                = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids # NOTE: NAT使いたくないのでプライベートサブネットは使わない
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      SERVICE_NAME = "line-message-batch"
      ENV          = "stg"
    }
  }

  tags = { Name = "${local.fqn}-batch" }
}

# Lambdaのイベントソースマッピングの設定
# SQSキューからのメッセージ受信をトリガーに、Lambadaを起動するために必要な設定
resource "aws_lambda_event_source_mapping" "line_message_batch" {
  event_source_arn = data.terraform_remote_state.sqs.outputs.line_message_lambda_process_standard_sqs.arn
  function_name    = aws_lambda_function.line_message_batch.arn
  enabled          = true
  batch_size       = 1
}
