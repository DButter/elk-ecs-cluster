resource "aws_route53_zone" "main" {
  name = var.dns
  vpc {
    vpc_id = var.vpc_id
  }
}
