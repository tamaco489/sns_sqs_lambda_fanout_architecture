resource "aws_route53_zone" "main" {
  name    = var.domain
  comment = "SNS × SQS × Lambda の fan-out アーキテクチャの検証で利用"
  tags    = { Name = "${var.env}-${var.project}" }
}
