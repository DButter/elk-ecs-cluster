data "aws_iam_policy_document" ecs_assume_policy {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" ecs_execution_policy {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" ecs_execution_policy {
  policy = data.aws_iam_policy_document.ecs_execution_policy.json
}

resource "aws_iam_role" ecs_execution_role {
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}

resource "aws_iam_role_policy_attachment" ecs_execution {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
}

//CloudWatch
data "aws_iam_policy_document" "cloudwatch" {
  policy_id = local.name
  statement {
    sid = "Enable IAM User Permissions"
    actions = [
      "kms:*",
    ]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::047951224472:root"]
    }
    resources = ["*"]
  }
  statement {
    sid = "AllowCloudWatchLogs"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["logs.eu-central-1.amazonaws.com"]
    }
    resources = ["*"]
  }
}
