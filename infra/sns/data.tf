data "terraform_remote_state" "sqs" {
  backend = "s3"
  config = {
    bucket = "${var.env}-sns-sqs-lambda-fanout-architecture"
    key    = "sqs/terraform.tfstate"
  }
}
