

data "archive_file" "lambda_zip_file" {
  type        = "zip"
  source_dir = "${path.module}/python"
  output_path = "${local.lambda_artifact_dir}/lambda.zip"
}

locals {
  name = "${var.name}-${random_string.this.id}"
}

resource "random_string" "this" {
  length = 8
  special= false
}


resource "aws_lambda_function" "this" {
  function_name = local.name
  filename      = data.archive_file.lambda_zip_file.output_path
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  role          = aws_iam_role.this.arn
  runtime          = local.python_version
  handler          = "lambda_function.lambda_handler"
  layers           = [aws_lambda_layer_version.lambda_layer.arn]
  timeout     = 900
  memory_size = 128
  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = concat([aws_security_group.this.id], var.webaccess_security_groups)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" this {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_network" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.lambda_network.arn
}

resource "aws_iam_policy" "lambda_network" {
  policy = data.aws_iam_policy_document.lambda_network.json
}

data "aws_iam_policy_document" lambda_network {
  statement {
    effect  = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_security_group" this {
  vpc_id      = var.vpc_id
  tags = var.tags
}
