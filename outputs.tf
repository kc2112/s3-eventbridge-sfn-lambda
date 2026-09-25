output "primary" {
  description = "Pipeline outputs in the primary region."
  value = {
    region              = module.primary.region
    bucket_name         = module.primary.bucket_name
    bucket_arn          = module.primary.bucket_arn
    input_queue_url     = module.primary.input_queue_url
    output_queue_url    = module.primary.output_queue_url
    sfn_name            = module.primary.sfn_name
    sfn_arn             = module.primary.sfn_arn
    process_lambda_name = module.primary.process_lambda_name
    throttle_lambda_name = module.primary.throttle_lambda_name
  }
}

output "secondary" {
  description = "Pipeline outputs in the secondary region. Null when primary_only is true."
  value = var.primary_only ? null : {
    region              = module.secondary[0].region
    bucket_name         = module.secondary[0].bucket_name
    bucket_arn          = module.secondary[0].bucket_arn
    input_queue_url     = module.secondary[0].input_queue_url
    output_queue_url    = module.secondary[0].output_queue_url
    sfn_name            = module.secondary[0].sfn_name
    sfn_arn             = module.secondary[0].sfn_arn
    process_lambda_name = module.secondary[0].process_lambda_name
    throttle_lambda_name = module.secondary[0].throttle_lambda_name
  }
}
