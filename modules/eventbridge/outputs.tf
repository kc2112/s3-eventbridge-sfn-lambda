output "event_rule_arn" {
  description = "ARN of the Object Created EventBridge rule that starts my_sfn."
  value       = aws_cloudwatch_event_rule.s3_object_created.arn
}

output "event_rule_name" {
  description = "Name of the Object Created EventBridge rule."
  value       = aws_cloudwatch_event_rule.s3_object_created.name
}

output "sfn_succeeded_rule_arn" {
  description = "ARN of the EventBridge rule that invokes Lambda after my_sfn succeeds."
  value       = aws_cloudwatch_event_rule.sfn_succeeded.arn
}
