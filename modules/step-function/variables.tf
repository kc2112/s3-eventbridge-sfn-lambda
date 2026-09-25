variable "state_machine_name" {
  description = "Step Functions state machine name."
  type        = string
}

variable "process_lambda_arn" {
  description = "ARN of the process_<region> Lambda invoked inside the state machine."
  type        = string
}

variable "output_queue_url" {
  description = "URL of the output SQS queue."
  type        = string
}

variable "output_queue_arn" {
  description = "ARN of the output SQS queue."
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention in days."
  type        = number
  default     = 30
}
