output "http_access_sec_group"{
  value = aws_security_group.allow_http_and_https.id
}

output "http_access_urls"{
  value = {
    "elk_url" = local.elastic_url,
    "elk_hq_url" = local.elastic_hq_url
  }
}

output "arns"{
  value = {
    "cluster_id" = aws_ecs_cluster.this.id,
    "elk_slave_service_id" = aws_ecs_service.ELK_slave.id
  }
}
