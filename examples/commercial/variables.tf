variable "primary" {
  description = "Primary commercial region."
  type        = string
  default     = "us-west-2"
}

variable "secondary" {
  description = "Secondary commercial region."
  type        = string
  default     = "us-east-1"
}

variable "primary_only" {
  description = "If true, deploy only the primary region."
  type        = bool
  default     = false
}

variable "bucket_name" {
  description = "S3 bucket name prefix."
  type        = string
  default     = "my-bucket"
}
