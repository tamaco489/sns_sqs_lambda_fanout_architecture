# NOTE: SNSのVPCエンドポイント本体 (SNS へ接続するための VPCエンドポイント) SNS側に定義すると循環参照になるため `service/api/shop/` に定義
resource "aws_vpc_endpoint" "sns_endpoint" {
  vpc_id              = data.terraform_remote_state.network.outputs.vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.sns"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.sns_endpoint.id]

  tags = { Name = "${local.fqn}-sns-vpc-endpoint" }
}
