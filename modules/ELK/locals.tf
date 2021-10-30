locals {
  name = "${var.name}-${random_id.this.id}"
  docker_def = templatefile("./templates/elastic.json.tpl",
 {
   name                = local.name
   container_image     = "docker.elastic.co/elasticsearch/elasticsearch:7.15.0-amd64"
   log_group           = aws_cloudwatch_log_group.ELK_log_group.name
   region              = "eu-central-1"
 })
}

resource "random_id" "this" {
  byte_length = 8
}
