resource "aws_ssm_parameter" "api_gateway_id" {
  name        = "/${var.application_service}/api-gateway-id"
  description = "The ID of the api gateway"
  type        = "String"
  value       = aws_api_gateway_rest_api.private.id
  overwrite   = true
}

resource "aws_ssm_parameter" "root_resource_id" {
  name        = "/${var.application_service}/api-root-resource-id"
  description = "The ID of the root resource of the api gateway"
  type        = "String"
  value       = aws_api_gateway_rest_api.private.root_resource_id
  overwrite   = true
}

resource "aws_ssm_parameter" "api_policy_json" {
  name        = "/${var.application_service}/api-policy-json"
  description = "Policy to allow from vpc endpoint to api gateway"
  type        = "SecureString"
  value       = data.aws_iam_policy_document.allow_from_vpc_endpoint_to_gateway.json
  overwrite   = true
}

