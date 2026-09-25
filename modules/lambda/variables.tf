variable "function_name" {
  description = "Lambda function name."
  type        = string
}

variable "bucket_name" {
  description = "Name of the source S3 bucket, passed to the function as BUCKET_NAME."
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the source S3 bucket. Used to grant s3:GetObject."
  type        = string
}

variable "timeout" {
  description = "Function timeout in seconds."
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Function memory in MB."
  type        = number
  default     = 256
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention in days."
  type        = number
  default     = 30
}

variable "handler" {
  description = "Lambda handler."
  type        = string
  default     = "throttle.handler"
}

variable "source_file" {
  description = "Path to the function source file, relative to this module."
  type        = string
  default     = "src/throttle.mjs"
}

variable "environment" {
  description = "Extra environment variables merged with BUCKET_NAME."
  type        = map(string)
  default     = {}
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrency. Null leaves the account default (no extra throttle)."
  type        = number
  default     = null
}

variable "attach_extra_policy" {
  description = "When true, attach extra_policy_json to the role. Must be a literal so count is known at plan time."
  type        = bool
  default     = false
}

variable "extra_policy_json" {
  description = "Extra IAM policy JSON attached when attach_extra_policy is true."
  type        = string
  default     = ""
}
