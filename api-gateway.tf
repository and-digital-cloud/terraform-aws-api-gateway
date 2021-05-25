resource "aws_api_gateway_rest_api" "private" {
  name                         = "api-${local.name}-private"
  disable_execute_api_endpoint = true
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.private.id]
  }

  tags = merge(
    {
      Name = "api-${local.name}-private"
    },
    local.tags,
  )
}

resource "aws_api_gateway_domain_name" "public" {
  domain_name              = "${var.prefix}.${var.public_zone_name}"
  regional_certificate_arn = module.acm.acm_certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    {
      Name = "api-domain-${local.name}-regional"
    },
    local.tags,
  )

  depends_on = [
    module.acm
  ]
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.private.id
  stage_name    = var.environment
  deployment_id = aws_api_gateway_deployment.this.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
      "caller"         = "$context.identity.caller",
      "httpMethod"     = "$context.httpMethod",
      "ip"             = "$context.identity.sourceIp",
      "protocol"       = "$context.protocol",
      "requestId"      = "$context.requestId",
      "requestTime"    = "$context.requestTime",
      "resourcePath"   = "$context.resourcePath",
      "responseLength" = "$context.responseLength",
      "status"         = "$context.status",
      "user"           = "$context.identity.user"
    })
  }

  tags = merge(
    {
      Name = "api-stage-${local.name}-private"
    },
    local.tags,
  )
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.private.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled        = true
    logging_level          = local.api_method_settings.logging_level
    throttling_burst_limit = local.api_method_settings.throttling_burst_limit
    throttling_rate_limit  = local.api_method_settings.throttling_rate_limit
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.private.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.get,
    aws_api_gateway_integration.mock]
}

resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.private.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.public.domain_name
}

resource "aws_api_gateway_request_validator" "basic" {
  name                        = "basic-validator-api"
  rest_api_id                 = aws_api_gateway_rest_api.private.id
  validate_request_body       = true
  validate_request_parameters = true
}

data "aws_iam_policy_document" "allow_from_vpc_endpoint_to_gateway" {
  statement {
    actions   = ["execute-api:Invoke"]
    resources = ["arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    effect    = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = [aws_vpc_endpoint.private.id]
    }
  }
}

resource "aws_api_gateway_rest_api_policy" "allow_from_vpc_endpoint_to_gateway" {
  rest_api_id = aws_api_gateway_rest_api.private.id
  policy      = data.aws_iam_policy_document.allow_from_vpc_endpoint_to_gateway.json
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}
