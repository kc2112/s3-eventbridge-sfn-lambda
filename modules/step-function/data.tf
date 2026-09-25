data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume" {
  statement {
    sid     = "AllowStatesAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.${data.aws_region.current.name}.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "my_sfn" {
  statement {
    sid       = "InvokeProcessLambda"
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [var.process_lambda_arn]
  }

  statement {
    sid       = "SendOutputQueue"
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [var.output_queue_arn]
  }

  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
}
