data "terraform_remote_state" "route53" {
  backend = "s3"
  config = {
    bucket = "${var.env}-sns-sqs-lambda-fanout-architecture"
    key    = "route53/terraform.tfstate"
  }
}
