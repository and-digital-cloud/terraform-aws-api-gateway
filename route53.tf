resource "aws_route53_record" "api_public" {
  zone_id = data.aws_route53_zone.public.id
  name    = aws_api_gateway_domain_name.public.domain_name
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.private.dns_name]
}
