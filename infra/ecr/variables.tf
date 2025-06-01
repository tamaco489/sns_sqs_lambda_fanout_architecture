variable "env" {
  description = "The environment in which the ecr will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "sns-sqs-lambda-fanout-architecture"
}

locals {
  fqn      = "${var.env}-${var.project}"
  shop_api = "${var.env}-shop-api"
}
