data "aws_vpc_endpoint_service" "execute_api" {
  service      = "execute-api"
  service_type = "Interface"
}

resource "aws_vpc_endpoint" "private" {
  vpc_id              = var.vpc_id
  service_name        = data.aws_vpc_endpoint_service.execute_api.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  private_dns_enabled = true

  security_group_ids = [aws_security_group.allow_vpc_to_api_gateway.id]

  tags = merge(
    {
      Name = "vpce-${local.name}"
    },
    local.tags,
  )
}
