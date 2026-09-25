resource "aws_iam_role" "process_data" {
  name               = "${var.state_machine_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_states.json
}

resource "aws_iam_role_policy" "process_data" {
  name   = "${var.state_machine_name}-policy"
  role   = aws_iam_role.process_data.id
  policy = data.aws_iam_policy_document.process_data.json
}

resource "aws_cloudwatch_log_group" "process_data" {
  name              = "/aws/vendedlogs/states/${var.state_machine_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_sfn_state_machine" "process_data" {
  name     = var.state_machine_name
  role_arn = aws_iam_role.process_data.arn
  type     = "STANDARD"

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.process_data.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }

  definition = jsonencode({
    Comment = "Invoke process-<region>, then enqueue the payload on the output queue."
    StartAt = "Process"
    States = {
      Process = {
        Type     = "Task"
        Resource = "arn:${data.aws_partition.current.partition}:states:::lambda:invoke"
        Parameters = {
          FunctionName = var.process_lambda_arn
          "Payload.$"  = "$"
        }
        Retry = [
          {
            ErrorEquals     = ["Lambda.ServiceException", "Lambda.AWSLambdaException", "Lambda.SdkClientException", "Lambda.TooManyRequestsException"]
            IntervalSeconds = 2
            MaxAttempts     = 3
            BackoffRate     = 2
          }
        ]
        ResultSelector = {
          "payload.$" = "$.Payload"
        }
        Next = "EnqueueOutput"
      }
      EnqueueOutput = {
        Type     = "Task"
        Resource = "arn:${data.aws_partition.current.partition}:states:::aws-sdk:sqs:sendMessage"
        Parameters = {
          QueueUrl        = var.output_queue_url
          "MessageBody.$" = "States.JsonToString($.payload)"
        }
        End = true
      }
    }
  })
}
