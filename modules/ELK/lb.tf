resource "aws_lb" "this" {
  name               = local.name
  internal           = true
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [aws_security_group.allow_http_and_https.id]
  idle_timeout = 300
  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_listener" "default_http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><body><h1>Not found</h1></body></html>"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.default_http.arn
  condition {
    host_header {
      values = [local.elastic_url]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  port     = 9200
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = var.tags
  target_type = "ip"
  health_check {
    protocol = "HTTP"
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = local.elastic_url
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener_rule" "rule_hq" {
  listener_arn = aws_lb_listener.default_http.arn
  condition {
    host_header {
      values = [local.elastic_hq_url]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this_hq.arn
  }
}

resource "aws_lb_target_group" "this_hq" {
  port     = local.elastic_hq_http_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = var.tags
  target_type = "ip"
  health_check {
    protocol = "HTTP"
  }
}

resource "aws_route53_record" "www_hq" {
  zone_id = aws_route53_zone.main.zone_id
  name    = local.elastic_hq_url
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
