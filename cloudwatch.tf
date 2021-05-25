resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "cwlg-${local.name}-api"
  retention_in_days = 7

  tags = merge(
    {
      Name = "cwlg-${local.name}-api"
    },
    local.tags
  )
}

data "aws_iam_policy_document" "api_gateway_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "rol-glob-${var.environment}-t-${var.application_service}"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role.json

  tags = merge(
    {
      Name = "rol-glob-${var.environment}-t-${var.application_service}"
    },
    local.tags,
  )
}

resource "aws_iam_policy_attachment" "cloudwatch_assume_role" {
  name       = "apigateway_to_cloudwatch_attachment"
  policy_arn = data.aws_iam_policy.gateway_to_cloudwatch.arn
  roles      = [aws_iam_role.cloudwatch.id]
}
