resource "aws_security_group" "line_message_batch" {
  name        = "${local.fqn}-batch"
  description = "security group for line message batch service running in the vpc"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-batch"
  }
}

resource "aws_vpc_security_group_egress_rule" "line_message_batch_egress" {
  security_group_id = aws_security_group.line_message_batch.id
  description       = "allow Lambda to access external resources (e.g. rds, dynamodb, api)"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
