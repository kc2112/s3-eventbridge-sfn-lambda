variable "primary" {
  description = "Primary AWS region for this stack."
  type        = string
  default     = "us-east-1" #"us-gov-west-1"
}

variable "secondary" {
  description = "Secondary AWS region for this stack. Ignored when primary_only is true."
  type        = string
  default     = "us-west-1" #"us-gov-east-1"
}

variable "primary_only" {
  description = "If true, deploy only the primary region."
  type        = bool
  default     = true
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
  default     = "my-bucket"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be a valid S3 name prefix (lowercase letters, numbers, dots, hyphens)."
  }
}

variable "lambda_function_name" {
  description = "Base Lambda name. A region suffix is appended."
  type        = string
  default     = "my_lambda"
}

variable "state_machine_name" {
  description = "Base state machine name. A region suffix is appended."
  type        = string
  default     = "my_sfn"
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
