variable "primary" {
  description = "Primary GovCloud region."
  type        = string
  default     = "us-gov-east-1"
}

variable "secondary" {
  description = "Secondary GovCloud region."
  type        = string
  default     = "us-gov-west-1"
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
