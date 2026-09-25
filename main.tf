locals {
  # us-gov-west-1 -> west-1 ; us-west-2 -> west-2
  suffix_primary   = replace(replace(var.primary, "us-gov-", ""), "us-", "")
  suffix_secondary = replace(replace(var.secondary, "us-gov-", ""), "us-", "")
}

module "primary" {
  source = "./modules/pipeline"

  prefix                 = var.prefix
  name_suffix            = local.suffix_primary
  bucket_name            = var.bucket_name
  throttle_function_name = var.throttle_function_name
  state_machine_name     = var.state_machine_name
  lambda_timeout         = var.lambda_timeout
  lambda_memory_mb       = var.lambda_memory_mb
  log_retention_days     = var.log_retention_days
}

module "secondary" {
  count  = var.primary_only ? 0 : 1
  source = "./modules/pipeline"

  providers = {
    aws = aws.secondary
  }

  prefix                 = var.prefix
  name_suffix            = local.suffix_secondary
  bucket_name            = var.bucket_name
  throttle_function_name = var.throttle_function_name
  state_machine_name     = var.state_machine_name
  lambda_timeout         = var.lambda_timeout
  lambda_memory_mb       = var.lambda_memory_mb
  log_retention_days     = var.log_retention_days
}
