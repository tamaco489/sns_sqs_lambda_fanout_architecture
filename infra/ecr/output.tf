output "shop_api" {
  value = {
    arn  = aws_ecr_repository.shop_api.arn
    id   = aws_ecr_repository.shop_api.id
    name = aws_ecr_repository.shop_api.name
    url  = aws_ecr_repository.shop_api.repository_url
  }
}

output "slack_message_batch" {
  value = {
    arn  = aws_ecr_repository.slack_message_batch.arn
    id   = aws_ecr_repository.slack_message_batch.id
    name = aws_ecr_repository.slack_message_batch.name
    url  = aws_ecr_repository.slack_message_batch.repository_url
  }
}
