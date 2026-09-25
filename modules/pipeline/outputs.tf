output "bucket_name" {
  description = "Physical S3 bucket name."
  value       = module.s3.bucket_name
}

output "bucket_arn" {
  description = "S3 bucket ARN."
  value       = module.s3.bucket_arn
}

output "input_queue_url" {
  description = "Ingest SQS queue URL (S3 → SFN throttle)."
  value       = module.input_queue.queue_url
}

output "input_queue_arn" {
  description = "Ingest SQS queue ARN."
  value       = module.input_queue.queue_arn
}

output "output_queue_url" {
  description = "Output SQS queue URL (SFN result)."
  value       = module.output_queue.queue_url
}

output "output_queue_arn" {
  description = "Output SQS queue ARN."
  value       = module.output_queue.queue_arn
}

output "sfn_name" {
  description = "State machine name."
  value       = module.step_function.state_machine_name
}

output "sfn_arn" {
  description = "State machine ARN."
  value       = module.step_function.state_machine_arn
}

output "process_lambda_name" {
  description = "Name of process_<region>."
  value       = module.process.function_name
}

output "process_lambda_arn" {
  description = "ARN of process_<region>."
  value       = module.process.function_arn
}

output "throttle_lambda_name" {
  description = "SQS throttle_fn Lambda name."
  value       = module.throttle.function_name
}

output "partition" {
  description = "AWS partition."
  value       = local.partition
}

output "region" {
  description = "AWS region for this pipeline copy."
  value       = local.region
}
