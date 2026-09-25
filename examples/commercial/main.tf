module "stack" {
  source = "../.."

  providers = {
    aws           = aws
    aws.secondary = aws.secondary
  }

  prefix       = "cmm"
  primary      = var.primary
  secondary    = var.secondary
  primary_only = var.primary_only
  bucket_name  = var.bucket_name
}
