variable "name" {
  description = "SQS queue name."
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds."
  type        = number
  default     = 180
}

variable "message_retention_seconds" {
  description = "How long messages are retained."
  type        = number
  default     = 1209600
}

variable "receive_wait_time_seconds" {
  description = "Long polling wait time."
  type        = number
  default     = 20
}

variable "max_receive_count" {
  description = "Receives before a message is sent to the DLQ."
  type        = number
  default     = 5
}

variable "allow_s3_notifications" {
  description = "When true, attach a queue policy allowing S3 to SendMessage. Must be a literal so count is known at plan time."
  type        = bool
  default     = false
}

variable "s3_bucket_arn" {
  description = "Bucket ARN allowed to SendMessage when allow_s3_notifications is true."
  type        = string
  default     = ""
}
