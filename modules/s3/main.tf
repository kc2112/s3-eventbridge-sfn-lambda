resource "aws_s3_bucket" "temp_storage" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "temp_storage" {
  bucket = aws_s3_bucket.temp_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "temp_storage" {
  bucket = aws_s3_bucket.temp_storage.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "temp_storage" {
  bucket = aws_s3_bucket.temp_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "temp_storage" {
  bucket = aws_s3_bucket.temp_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Notifications are attached by the pipeline after the input queue exists.
