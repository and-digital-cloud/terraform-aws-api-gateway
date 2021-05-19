module "acm" {
  source = "git::ssh://git@gitlab.com/cef-cloud/core-modules/terraform/acm.git?ref=2.0.0"

  domain_name = "${var.prefix}.${var.public_zone_name}"
  zone_id     = data.aws_route53_zone.public.id

  tags = merge(
    {
      Name = "crt-${local.name}"
    },
    local.tags,
  )
}
