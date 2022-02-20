locals {
  // All lambda codes zip and layer zip file directory
  lambda_artifact_dir = "${path.module}/lambda_zip"
  lambda_layer_zipfile_name = "layer"
  python_version = "python3.7"
}

// Generate zipfile for lambda layer
resource "null_resource" "build_lambda_layer" {
  provisioner "local-exec" {
    when    = create
    command = "./${path.module}/build_layer.sh"

    environment = {
      DESTINATION_DIR = abspath(local.lambda_artifact_dir)
      MODULE_DIR      = abspath(path.module)
      ZIPFILE_NAME      = local.lambda_layer_zipfile_name
    }
  }

  triggers = {
    // Trigger only when something changes in Pipfile
    run_on_pipfile_change = filemd5("${abspath(path.module)}/python/requirements.txt")
  }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename            = "${local.lambda_artifact_dir}/${local.lambda_layer_zipfile_name}.zip"
  layer_name          = "lambda_layer"
  compatible_runtimes = [local.python_version]
  // It will run after lambda layer zipfile build
  depends_on          = [null_resource.build_lambda_layer]

  lifecycle {
    create_before_destroy = true
  }
}
