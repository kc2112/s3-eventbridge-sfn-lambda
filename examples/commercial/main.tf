module "stack" {
  source = "../.."

  providers = {
    aws           = aws
    aws.secondary = aws.secondary
  }

  primary      = var.primary
  secondary    = var.secondary
  primary_only = var.primary_only
  bucket_name          = var.bucket_name
  lambda_function_name = "my_lambda"
  state_machine_name   = "my_sfn"
}
