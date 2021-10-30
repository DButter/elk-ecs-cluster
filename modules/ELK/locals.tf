locals {
  name = "${var.name}-${random_id.this.id}"
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

}

resource "random_id" "this" {
  byte_length = 8
}
