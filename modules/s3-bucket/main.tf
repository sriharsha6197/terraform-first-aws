provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  for_each = length(var.buckets_to_create)
  bucket = "${var.buckets_to_create[for_each.index]}"

}
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  count = length(var.buckets_to_create)
  bucket = "${var.buckets_to_create[count.index]}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  count = length(var.buckets_to_create)
  bucket = "${var.buckets_to_create[count.index]}"
  versioning_configuration {
    status = "Enabled"
  }
}