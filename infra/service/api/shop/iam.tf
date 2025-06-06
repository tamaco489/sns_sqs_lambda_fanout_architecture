# =================================================================
# basic iam policy
# =================================================================
data "aws_iam_policy_document" "lambda_execution_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "shop_api" {
  name               = "${local.fqn}-api-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_assume_role.json
  tags               = { Name = "${local.fqn}-api" }
}

# https://docs.aws.amazon.com/ja_jp/aws-managed-policy/latest/reference/AWSLambdaVPCAccessExecutionRole.html
resource "aws_iam_role_policy_attachment" "shop_api_execution_role" {
  role       = aws_iam_role.shop_api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# =================================================================
# sns iam policy
# =================================================================
data "aws_iam_policy_document" "shop_api_sns_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      data.terraform_remote_state.sns.outputs.fanout_notifications.arn
    ]
  }
}

resource "aws_iam_policy" "shop_api_sns_policy" {
  name        = "${local.fqn}-api-sns-policy"
  description = "Allow Lambda to SNS topic"
  policy      = data.aws_iam_policy_document.shop_api_sns_policy.json
}

resource "aws_iam_role_policy_attachment" "shop_api_sns_policy" {
  role       = aws_iam_role.shop_api.name
  policy_arn = aws_iam_policy.shop_api_sns_policy.arn
}
