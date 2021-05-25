data "aws_network_interface" "virtual_interface" {
  for_each = {
    for subnet_id in keys(data.aws_network_interfaces.this) :
    subnet_id => tolist(setintersection(data.aws_network_interfaces.this[subnet_id].ids, aws_vpc_endpoint.private.network_interface_ids))[0]
  }
  id = each.value
}

data "aws_network_interfaces" "this" {
  for_each = toset(var.private_subnet_ids)
  filter {
    name   = "subnet-id"
    values = [each.value]
  }

  depends_on = [
    aws_vpc_endpoint.private
  ]
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy" "gateway_to_cloudwatch" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_route53_zone" "public" {
  name = var.public_zone_name
}

