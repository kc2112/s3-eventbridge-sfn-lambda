locals {
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # AWS resource names: kebab-case. Underscores in inputs are normalized.
  prefix     = replace(var.prefix, "_", "-")
  suffix     = replace(var.name_suffix, "_", "-")
  bucket_base = replace(var.bucket_name, "_", "-")
  throttle   = replace(var.throttle_function_name, "_", "-")
  sfn        = replace(var.state_machine_name, "_", "-")

  bucket_name         = "${local.prefix}-${local.bucket_base}-${local.suffix}-${local.account_id}"
  process_lambda_name = "${local.prefix}-process-${local.region}"
  throttle_fn_name    = "${local.prefix}-${local.throttle}-${local.suffix}"
  state_machine_name  = "${local.prefix}-${local.sfn}-${local.suffix}"
  input_queue_name    = "${local.prefix}-input-queue-${local.suffix}"
  output_queue_name   = "${local.prefix}-output-queue-${local.suffix}"
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

data "aws_iam_policy_document" "throttle" {
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

module "throttle" {
  source = "../lambda"

  function_name                  = local.throttle_fn_name
  bucket_name                    = module.s3.bucket_name
  bucket_arn                     = module.s3.bucket_arn
  timeout                        = var.lambda_timeout
  memory_size                    = var.lambda_memory_mb
  log_retention_days             = var.log_retention_days
  handler                        = "throttle.handler"
  source_file                    = "src/throttle.mjs"
  reserved_concurrent_executions = var.throttle_reserved_concurrency
  attach_extra_policy            = true
  extra_policy_json              = data.aws_iam_policy_document.throttle.json
  environment = {
    STATE_MACHINE_ARN = module.step_function.state_machine_arn
  }
}

resource "aws_lambda_event_source_mapping" "input_queue" {
  event_source_arn                   = module.input_queue.queue_arn
  function_name                      = module.throttle.function_arn
  batch_size                         = var.throttle_batch_size
  maximum_batching_window_in_seconds = 0
  enabled                            = true

  scaling_config {
    maximum_concurrency = var.throttle_reserved_concurrency
  }
}
