resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name
  force_destroy = true  # Used this because it's for practice. All contents with S3 bucket will be destroyed.


  tags = {
    Name        = var.state_bucket_name
    Purpose     = "Terraform State"
    Environment = var.environment
  }
}


# Enable versioning so previous state versions can be recovered.
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt objects stored in the bucket.
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Prevent the state bucket from becoming public.
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}