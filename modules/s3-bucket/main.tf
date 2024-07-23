provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my-tf-test-bucket-harsha" {
  bucket = "my-tf-test-bucket-harsha"
}
resource "aws_s3_bucket_acl" "acl_bucket" {
  bucket = aws_s3_bucket.my-tf-test-bucket-harsha.id
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.my-tf-test-bucket-harsha.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.my-tf-test-bucket-harsha.id
  versioning_configuration {
    status = "Enabled"
  }
}