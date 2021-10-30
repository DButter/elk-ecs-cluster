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

resource "aws_ecs_task_definition" ELK {
  family = local.name

  task_role_arn            = aws_iam_role.ecs_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = local.docker_def
}

resource "aws_ecs_service" ELK {
  name = local.name

  task_definition  = aws_ecs_task_definition.ELK.arn
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
  }
}
