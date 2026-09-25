variable "bucket_name" {
  description = "Physical S3 bucket name. Must be globally unique and S3-compliant."
  type        = string
}

variable "notification_queue_arn" {
  description = "SQS queue ARN for s3:ObjectCreated:* notifications. Leave null to disable notifications."
  type        = string
  default     = null
}
