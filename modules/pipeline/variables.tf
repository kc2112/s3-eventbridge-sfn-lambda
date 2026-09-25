variable "name_suffix" {
  description = "Short suffix appended to bucket, Lambda, and state machine names so two regions in one account do not collide (e.g. west-1)."
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name prefix. Account ID and name_suffix are appended."
  type        = string
}

variable "lambda_function_name" {
  description = "Base Lambda function name. name_suffix is appended."
  type        = string
}

variable "state_machine_name" {
  description = "Base Step Functions name. name_suffix is appended."
  type        = string
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 30
}

variable "lambda_memory_mb" {
  description = "Lambda memory in MB."
  type        = number
  default     = 256
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention in days."
  type        = number
  default     = 30
}

variable "starter_reserved_concurrency" {
  description = "Reserved concurrency for the SQS starter Lambda. Caps how many Step Functions executions start at once."
  type        = number
  default     = 5
}

variable "starter_batch_size" {
  description = "SQS records per starter invocation."
  type        = number
  default     = 1
}
