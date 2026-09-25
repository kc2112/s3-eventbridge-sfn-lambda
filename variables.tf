variable "primary" {
  description = "Primary AWS region for this stack."
  type        = string
  default     = "us-gov-east-1"
}

variable "secondary" {
  description = "Secondary AWS region for this stack. Ignored when primary_only is true."
  type        = string
  default     = "us-gov-west-1"
}

variable "primary_only" {
  description = "If true, deploy only the primary region."
  type        = bool
  default     = false
}

variable "prefix" {
  description = "Name prefix applied to all created resources."
  type        = string
  default     = "cmm"

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.prefix))
    error_message = "prefix must be lowercase alphanumeric segments separated by hyphens (e.g. cmm or cmm-app). No leading, trailing, or doubled hyphens."
  }
}

variable "tags" {
  description = "Tags applied via provider default_tags."
  type        = map(string)
  default = {
    Project   = "s3-eventbridge-sfn-lambda"
    ManagedBy = "terraform"
  }
}

variable "bucket_name" {
  description = "S3 bucket name prefix. Suffix and account ID are appended per region."
  type        = string
  default     = "temp-storage"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be a valid S3 name prefix (lowercase letters, numbers, dots, hyphens)."
  }
}

variable "throttle_function_name" {
  description = "Base name of the SQS throttle Lambda. Prefix and region suffix are applied."
  type        = string
  default     = "throttle-fn"
}

variable "state_machine_name" {
  description = "Base state machine name. Prefix and region suffix are applied."
  type        = string
  default     = "process-data"
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
