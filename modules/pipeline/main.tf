locals {
  partition           = data.aws_partition.current.partition
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  bucket_name         = "${var.bucket_name}-${var.name_suffix}-${local.account_id}"
  process_lambda_name = "process_${local.region}"
  starter_lambda_name = "sfn_starter_${var.name_suffix}"
  state_machine_name  = "${var.state_machine_name}_${var.name_suffix}"
  input_queue_name    = "s3-ingest-${var.name_suffix}"
  output_queue_name   = "sfn-output-${var.name_suffix}"
}

module "s3" {
  source = "../s3"

  bucket_name = local.bucket_name
}

module "input_queue" {
  source = "../sqs"

  name                       = local.input_queue_name
  allow_s3_notifications     = true
  s3_bucket_arn              = module.s3.bucket_arn
  visibility_timeout_seconds = var.lambda_timeout * 6
}

module "output_queue" {
  source = "../sqs"

  name = local.output_queue_name
}

resource "aws_s3_bucket_notification" "to_sqs" {
  bucket = module.s3.bucket_id

  queue {
    queue_arn = module.input_queue.queue_arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [module.input_queue]
}

module "process" {
  source = "../lambda"

  function_name      = local.process_lambda_name
  bucket_name        = module.s3.bucket_name
  bucket_arn         = module.s3.bucket_arn
  timeout            = var.lambda_timeout
  memory_size        = var.lambda_memory_mb
  log_retention_days = var.log_retention_days
  handler            = "passthrough.handler"
  source_file        = "src/passthrough.mjs"
}

module "step_function" {
  source = "../step-function"

  state_machine_name = local.state_machine_name
  process_lambda_arn = module.process.function_arn
  output_queue_url   = module.output_queue.queue_url
  output_queue_arn   = module.output_queue.queue_arn
  log_retention_days = var.log_retention_days
}

data "aws_iam_policy_document" "starter" {
  statement {
    sid       = "StartExecution"
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = [module.step_function.state_machine_arn]
  }

  statement {
    sid    = "ConsumeInputQueue"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ChangeMessageVisibility",
    ]
    resources = [module.input_queue.queue_arn]
  }
}

module "starter" {
  source = "../lambda"

  function_name                  = local.starter_lambda_name
  bucket_name                    = module.s3.bucket_name
  bucket_arn                     = module.s3.bucket_arn
  timeout                        = var.lambda_timeout
  memory_size                    = var.lambda_memory_mb
  log_retention_days             = var.log_retention_days
  handler                        = "starter.handler"
  source_file                    = "src/starter.mjs"
  reserved_concurrent_executions = var.starter_reserved_concurrency
  attach_extra_policy            = true
  extra_policy_json              = data.aws_iam_policy_document.starter.json
  environment = {
    STATE_MACHINE_ARN = module.step_function.state_machine_arn
  }
}

resource "aws_lambda_event_source_mapping" "input_queue" {
  event_source_arn                   = module.input_queue.queue_arn
  function_name                      = module.starter.function_arn
  batch_size                         = var.starter_batch_size
  maximum_batching_window_in_seconds = 0
  enabled                            = true

  scaling_config {
    maximum_concurrency = var.starter_reserved_concurrency
  }
}
