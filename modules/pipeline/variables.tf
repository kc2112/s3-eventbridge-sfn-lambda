variable "prefix" {
  description = "Name prefix applied to all resources in this region."
  type        = string
}

variable "name_suffix" {
  description = "Short suffix so two regions in one account do not collide (e.g. west-1)."
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket base name. Prefix, suffix, and account ID are applied."
  type        = string
}

variable "throttle_function_name" {
  description = "Base throttle Lambda name."
  type        = string
}

variable "state_machine_name" {
  description = "Base Step Functions name."
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

variable "throttle_reserved_concurrency" {
  description = "Reserved concurrency for throttle_fn. Caps how many Step Functions executions start at once."
  type        = number
  default     = 5
}

variable "throttle_batch_size" {
  description = "SQS records per throttle_fn invocation."
  type        = number
  default     = 1
}
