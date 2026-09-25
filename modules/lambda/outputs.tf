output "function_name" {
  description = "Lambda function name."
  value       = aws_lambda_function.my_lambda.function_name
}

output "function_arn" {
  description = "Lambda function ARN."
  value       = aws_lambda_function.my_lambda.arn
}

output "role_name" {
  description = "Execution role name."
  value       = aws_iam_role.my_lambda.name
}

output "role_arn" {
  description = "Execution role ARN."
  value       = aws_iam_role.my_lambda.arn
}
