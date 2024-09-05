variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name
}
