resource "aws_lb" "private" {
  name               = "nlb-${local.name}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    {
      Name = "nlb-apig-${local.name}"
    },
    local.tags,
  )
}

resource "aws_lb_listener" "forwarder" {
  load_balancer_arn = aws_lb.private.arn
  port              = "443"
  protocol          = "TLS"
  certificate_arn   = module.acm.acm_certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vpc_endpoints.arn
  }
}

resource "aws_lb_target_group" "vpc_endpoints" {
  name        = "api-gateway-target"
  port        = 443
  protocol    = "TLS"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "vpc_endpoint_ips" {
  for_each = data.aws_network_interface.virtual_interface

  target_group_arn = aws_lb_target_group.vpc_endpoints.arn
  target_id        = each.value.private_ip
}
