resource "aws_s3_bucket" "my-tf-test-bucket" {
  bucket = "my-tf-test-bucket"
}
resource "aws_s3_bucket_acl" "acl_bucket" {
  bucket = aws_s3_bucket.my-tf-test-bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.my-tf-test-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.my-tf-test-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}