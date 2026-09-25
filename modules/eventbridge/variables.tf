variable "bucket_name" {
  description = "S3 bucket name used in the EventBridge event pattern."
  type        = string
}

variable "state_machine_arn" {
  description = "ARN of the Step Functions state machine that receives Object Created events."
  type        = string
}

variable "state_machine_name" {
  description = "State machine name, used in IAM role and rule names."
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda function invoked after the state machine succeeds."
  type        = string
}

variable "lambda_name" {
  description = "Name of the Lambda function invoked after the state machine succeeds."
  type        = string
}
