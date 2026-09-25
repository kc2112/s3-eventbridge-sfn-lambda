output "bucket_name" {
  description = "Name of the temp-storage bucket."
  value       = aws_s3_bucket.temp_storage.bucket
}

output "bucket_arn" {
  description = "ARN of the temp-storage bucket."
  value       = aws_s3_bucket.temp_storage.arn
}

output "bucket_id" {
  description = "ID of the temp-storage bucket."
  value       = aws_s3_bucket.temp_storage.id
}
