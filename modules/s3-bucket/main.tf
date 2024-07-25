provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  for_each = var.buckets_to_create
  bucket = "${each.key}_${var.env}"

}
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  for_each = var.buckets_to_create
  bucket = "${each.key}_${var.env}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  for_each = var.buckets_to_create
  bucket = "${each.key}_${var.env}"
  versioning_configuration {
    status = "Enabled"
  }
}