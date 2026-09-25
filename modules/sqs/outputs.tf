output "queue_name" {
  description = "Queue name."
  value       = aws_sqs_queue.queue.name
}

output "queue_arn" {
  description = "Queue ARN."
  value       = aws_sqs_queue.queue.arn
}

output "queue_url" {
  description = "Queue URL."
  value       = aws_sqs_queue.queue.id
}

output "dlq_arn" {
  description = "Dead-letter queue ARN."
  value       = aws_sqs_queue.dlq.arn
}

output "dlq_url" {
  description = "Dead-letter queue URL."
  value       = aws_sqs_queue.dlq.id
}
