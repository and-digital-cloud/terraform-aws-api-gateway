locals {
  tags = {
    Service         = var.application_service
    ApplicationRole = var.application_role
    Environment     = var.environment
    Project         = var.project
    Region          = data.aws_region.current.name
    Confidentiality = var.confidentiality
    Compliance      = var.compliance
  }

  region_parts = split("-", data.aws_region.current.name)
  region_id    = "${local.region_parts[0]}${substr(local.region_parts[1], 0, 1)}${local.region_parts[2]}"
  name         = "${local.region_id}-${var.environment}-t-${var.project}-${var.application_service}"

  api_method_settings = {
    "logging_level"          = "INFO"
    "throttling_burst_limit" = "50"
    "throttling_rate_limit"  = "100"
  }
}

