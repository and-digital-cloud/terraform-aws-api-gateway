module "acm" {
  source = "https://github.com/terraform-aws-modules/terraform-aws-acm.git"
  version = "~> 3.2"

  domain_name = "${var.prefix}.${var.public_zone_name}"
  zone_id     = data.aws_route53_zone.public.id

  tags = merge(
    {
      Name = "crt-${local.name}-api-domain"
    },
    local.tags,
  )
}

