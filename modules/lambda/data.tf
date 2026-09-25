data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "assume" {
  statement {
    sid     = "AllowLambdaAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "my_lambda" {
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.function_name}",
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.function_name}:*",
    ]
  }

  statement {
    sid       = "ReadTriggerObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${var.bucket_arn}/*"]
  }
}

data "archive_file" "my_lambda" {
  type        = "zip"
  source_file = "${path.module}/${var.source_file}"
  output_path = "${path.module}/src/${var.function_name}.zip"
}
