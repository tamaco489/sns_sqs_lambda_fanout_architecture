variable "env" {
  description = "The environment in which the sns will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "fanout-architecture"
}

variable "region" {
  description = "The region in which the sns will be created"
  type        = string
  default     = "ap-northeast-1"
}

locals {
  fqn = "${var.env}-${var.project}"
}
