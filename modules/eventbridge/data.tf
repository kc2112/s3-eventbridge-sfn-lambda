data "aws_iam_policy_document" "assume" {
  statement {
    sid     = "AllowEventsAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "events_to_sfn" {
  statement {
    sid       = "StartExecution"
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = [var.state_machine_arn]
  }
}
