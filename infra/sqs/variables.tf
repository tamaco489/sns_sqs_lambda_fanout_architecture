variable "env" {
  description = "The environment in which the sqs will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "fanout-architecture"
}

variable "region" {
  description = "The region in which the sqs will be created"
  type        = string
  default     = "ap-northeast-1"
}

locals {
  fqn = "${var.env}-${var.project}"

  # sqs
  slack_message_sqs = "${var.env}-slack-message-sqs"
  line_message_sqs  = "${var.env}-line-message-sqs"

  # dql
  slack_message_dlq = "${var.env}-slack-message-dlq"
  line_message_dlq   = "${var.env}-line-message-dlq"
}
