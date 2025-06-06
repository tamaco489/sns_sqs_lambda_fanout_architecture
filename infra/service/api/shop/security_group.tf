resource "aws_security_group" "shop_api" {
  name        = "${local.fqn}-api"
  description = "Security group for API service running in the VPC"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = { Name = "${local.fqn}-api" }
}

# SNS VPCエンドポイント用セキュリティグループ
resource "aws_security_group" "sns_endpoint" {
  name        = "${local.fqn}-sns-endpoint"
  description = "Security group for SNS VPC Endpoint"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = { Name = "${local.fqn}-sns-endpoint" }
}

# shop_api セキュリティグループ → sns_endpoint セキュリティグループ への HTTPS 通信許可（egress）
resource "aws_vpc_security_group_egress_rule" "shop_api_to_sns_endpoint" {
  security_group_id            = aws_security_group.shop_api.id
  description                  = "Allow HTTPS to SNS VPC endpoint"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.sns_endpoint.id
}

# sns_endpoint セキュリティグループ ← shop_api  セキュリティグループ からの HTTPS 通信許可（ingress）
resource "aws_vpc_security_group_ingress_rule" "sns_endpoint_from_shop_api" {
  security_group_id            = aws_security_group.sns_endpoint.id
  description                  = "Allow HTTPS from API"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.shop_api.id
}
