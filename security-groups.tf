resource "aws_security_group" "allow_vpc_to_api_gateway" {
  name = "sgr-${local.region_id}-${var.environment}-t-${var.project}-api-gw"

  description = "Allow access between the vpc and the api gateway"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.this.cidr_block, var.vpn_cidr_block]
  security_group_id = aws_security_group.allow_vpc_to_api_gateway.id
}

