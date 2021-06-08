resource "aws_api_gateway_resource" "demo" {
  rest_api_id = aws_api_gateway_rest_api.private.id
  parent_id   = aws_api_gateway_rest_api.private.root_resource_id
  path_part   = "demo"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.private.id
  resource_id   = aws_api_gateway_resource.demo.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "mock" {
  rest_api_id = aws_api_gateway_rest_api.private.id
  resource_id = aws_api_gateway_resource.demo.id
  http_method = aws_api_gateway_method.get.http_method
  type        = "MOCK"
}

