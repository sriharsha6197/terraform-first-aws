provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  count = length(var.buckets_to_create)
  bucket = "${var.buckets_to_create}"
  
}
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  count = length(var.buckets_to_create)
  bucket = "${var.buckets_to_create}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  count = length(var.buckets_to_create)
  bucket = "${var.buckets_to_create}"
  versioning_configuration {
    status = "Enabled"
  }
}