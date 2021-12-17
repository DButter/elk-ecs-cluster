locals {
  name = "${var.name}-${random_string.this.id}"
  docker_def = templatefile("./templates/elastic.json.tpl",
 {
   name                = local.name
   masters             = join(",",local.masters)
   container_image     = "docker.elastic.co/elasticsearch/elasticsearch:7.15.0-amd64"
   discovery_seed_hosts = "node.${local.name}"
   log_group           = aws_cloudwatch_log_group.ELK_log_group.name
   region              = "eu-central-1"
 })
 elastic_http_port = 9200
 elastic_trans_port = 9300
 masters = ["master00","master01","master02"]
 elastic_hq_http_port = 5000
 elastic_url = "elastic.${var.dns}"
 docker_hq_def = templatefile("./templates/elastic_hq.json.tpl",
{
  name                = local.name
  default_url         = "http://${local.elastic_url}:80"
  container_image     = "elastichq/elasticsearch-hq"
  log_group           = aws_cloudwatch_log_group.ELK_log_group.name
  region              = "eu-central-1"
})
 elastic_hq_url = "elastic_hq.${var.dns}"
}


resource "random_string" "this" {
  length = 8
  special= false
}
