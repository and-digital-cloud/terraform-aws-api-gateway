resource "aws_ssm_parameter" "api_gateway_id" {
  name        = "/${var.environment}/${var.application_service}/api-gateway-id"
  description = "The ID of the api gateway"
  type        = "String"
  value       = aws_api_gateway_rest_api.private.id
  overwrite   = true
}

resource "aws_ssm_parameter" "root_resource_id" {
  name        = "/${var.environment}/${var.application_service}/api-root-resource-id"
  description = "The ID of the root resource of the api gateway"
  type        = "String"
  value       = aws_api_gateway_rest_api.private.root_resource_id
  overwrite   = true
}
