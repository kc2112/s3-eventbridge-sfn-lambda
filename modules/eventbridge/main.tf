resource "aws_iam_role" "events_to_sfn" {
  name               = "events-to-${var.state_machine_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy" "events_to_sfn" {
  name   = "events-to-${var.state_machine_name}-policy"
  role   = aws_iam_role.events_to_sfn.id
  policy = data.aws_iam_policy_document.events_to_sfn.json
}

resource "aws_cloudwatch_event_rule" "s3_object_created" {
  name        = "s3-${var.bucket_name}-object-created"
  description = "S3 Object Created on my_bucket -> my_sfn"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [var.bucket_name]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "my_sfn" {
  rule      = aws_cloudwatch_event_rule.s3_object_created.name
  target_id = "my_sfn"
  arn       = var.state_machine_arn
  role_arn  = aws_iam_role.events_to_sfn.arn

  retry_policy {
    maximum_event_age_in_seconds = 3600
    maximum_retry_attempts       = 2
  }
}

resource "aws_cloudwatch_event_rule" "sfn_succeeded" {
  name        = "${var.state_machine_name}-succeeded"
  description = "my_sfn SUCCEEDED -> my_lambda"

  event_pattern = jsonencode({
    source      = ["aws.states"]
    detail-type = ["Step Functions Execution Status Change"]
    detail = {
      status          = ["SUCCEEDED"]
      stateMachineArn = [var.state_machine_arn]
    }
  })
}

resource "aws_cloudwatch_event_target" "my_lambda" {
  rule      = aws_cloudwatch_event_rule.sfn_succeeded.name
  target_id = "my_lambda"
  arn       = var.lambda_arn

  retry_policy {
    maximum_event_age_in_seconds = 3600
    maximum_retry_attempts       = 2
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sfn_succeeded.arn
}
