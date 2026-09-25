resource "aws_iam_role" "my_lambda" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy" "my_lambda" {
  name   = "${var.function_name}-policy"
  role   = aws_iam_role.my_lambda.id
  policy = data.aws_iam_policy_document.my_lambda.json
}

resource "aws_iam_role_policy" "extra" {
  count  = var.attach_extra_policy ? 1 : 0
  name   = "${var.function_name}-extra"
  role   = aws_iam_role.my_lambda.id
  policy = var.extra_policy_json
}

resource "aws_cloudwatch_log_group" "my_lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_lambda_function" "my_lambda" {
  function_name = var.function_name
  role          = aws_iam_role.my_lambda.arn
  handler       = var.handler
  runtime       = "nodejs24.x"
  architectures = ["x86_64"]
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions

  filename         = data.archive_file.my_lambda.output_path
  source_code_hash = data.archive_file.my_lambda.output_base64sha256

  environment {
    variables = merge(
      { BUCKET_NAME = var.bucket_name },
      var.environment,
    )
  }

  depends_on = [aws_cloudwatch_log_group.my_lambda]
}
