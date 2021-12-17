resource "aws_ecs_cluster" this {
  name = local.name

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.this.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
      }
    }
  }
}

resource "aws_kms_key" this {
  description             = local.name
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" this {
  name = local.name
  retention_in_days = 1
}

resource "aws_kms_key" "cloudwatch" {
  description  = "KMS for cloudwatch log group"
  policy  = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_cloudwatch_log_group" ELK_log_group {
  name              = "ELK_task"
  kms_key_id        = aws_kms_key.cloudwatch.arn
  retention_in_days = 1
}

resource "aws_ecs_task_definition" ELK_slave {
  family = "${local.name}-slave"

  task_role_arn            = aws_iam_role.ecs_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = local.docker_def
}

resource "aws_ecs_service" ELK_slave {
  name = "${local.name}-slave"

  task_definition  = aws_ecs_task_definition.ELK_slave.arn
  cluster          = aws_ecs_cluster.this.id
  desired_count    = 5
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  // Assuming we cannot have more than one instance at a time. Ever.
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
    container_port =  local.elastic_trans_port
    container_name = local.name
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_port   = local.elastic_http_port
    container_name   = local.name
  }
}

resource "aws_ecs_task_definition" ELK_master {
  for_each = toset(local.masters)
  family = "${local.name}-${each.key}"

  task_role_arn            = aws_iam_role.ecs_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = templatefile("./templates/elastic_master.json.tpl",
                             {
                               name                = local.name
                               node_name           = each.key
                               masters             = join(",",local.masters)
                               container_image     = "docker.elastic.co/elasticsearch/elasticsearch:7.15.0-amd64"
                               discovery_seed_hosts = "node.${local.name}"
                               log_group           = aws_cloudwatch_log_group.ELK_log_group.name
                               region              = "eu-central-1"
                             })
}

resource "aws_ecs_service" ELK_master {
  for_each = toset(local.masters)
  name = "${local.name}-${each.key}"

  task_definition  = aws_ecs_task_definition.ELK_master[each.key].arn
  cluster          = aws_ecs_cluster.this.id
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  // Assuming we cannot have more than one instance at a time. Ever.
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
    container_port =  local.elastic_trans_port
    container_name = local.name
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_port   = local.elastic_http_port
    container_name   = local.name
  }
}

resource "aws_ecs_task_definition" ELK_hq {
  family = "${local.name}-elastic-hq"

  task_role_arn            = aws_iam_role.ecs_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = local.docker_hq_def
}

resource "aws_ecs_service" ELK_hq {
  name = "${local.name}-elastic-hq"

  task_definition  = aws_ecs_task_definition.ELK_hq.arn
  cluster          = aws_ecs_cluster.this.id
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  // Assuming we cannot have more than one instance at a time. Ever.
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.this.id, aws_security_group.allow_http_and_https.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this_hq.arn
    container_port   = local.elastic_hq_http_port
    container_name   = local.name
  }
}
