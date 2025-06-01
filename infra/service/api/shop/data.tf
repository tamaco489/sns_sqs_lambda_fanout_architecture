data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "${var.env}-sns-sqs-lambda-fanout-architecture"
    key    = "ecr/terraform.tfstate"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "${var.env}-sns-sqs-lambda-fanout-architecture"
    key    = "acm/terraform.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-sns-sqs-lambda-fanout-architecture"
    key    = "network/terraform.tfstate"
  }
}

# AWS マネージド型キー
data "aws_kms_key" "secretsmanager" {
  key_id = "alias/aws/secretsmanager"
}
