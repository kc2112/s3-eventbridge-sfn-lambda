resource "aws_iam_role" "execution" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
}

resource "aws_iam_role_policy" "logs_and_s3_read" {
  name   = "${var.function_name}-logs-s3-read"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.logs_and_s3_read.json
}

resource "aws_iam_role_policy" "extra_permissions" {
  count  = var.attach_extra_policy ? 1 : 0
  name   = "${var.function_name}-extra"
  role   = aws_iam_role.execution.id
  policy = var.extra_policy_json
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_lambda_function" "function" {
  function_name                  = var.function_name
  role                           = aws_iam_role.execution.arn
  handler                        = var.handler
  runtime                        = "nodejs24.x"
  architectures                  = ["x86_64"]
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions

  filename         = data.archive_file.package.output_path
  source_code_hash = data.archive_file.package.output_base64sha256

  environment {
    variables = merge(
      { BUCKET_NAME = var.bucket_name },
      var.environment,
    )
  }

  depends_on = [aws_cloudwatch_log_group.logs]
}
