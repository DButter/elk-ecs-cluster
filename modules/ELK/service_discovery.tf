resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = local.name
  description = "private namespace for elastic cluster"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "this" {
  name = local.name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
