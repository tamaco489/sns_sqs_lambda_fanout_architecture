resource "aws_cloudwatch_log_group" "line_message_batch" {
  name              = "/aws/lambda/${aws_lambda_function.line_message_batch.function_name}"
  retention_in_days = 3

  tags = { Name = "${local.fqn}-batch" }
}
