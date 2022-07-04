provider "aws"{
    region= var.aws-region
}

resource "aws_s3_bucket" "S3_website_proyect" {
    bucket = var.bucket_prefix
    force_destroy = true
}
resource "aws_s3_bucket_acl" "Acl_S3_bucket" {
  bucket = aws_s3_bucket.S3_website_proyect.id
  acl = var.acl
}
resource "aws_s3_bucket_policy" "S3_static_website_policy" {
  bucket = aws_s3_bucket.S3_website_proyect.id                       
  policy = data.aws_iam_policy_document.ima_policy_website_s3.json
}
resource "aws_s3_bucket_website_configuration" "s3_website_configuration" {
  bucket = aws_s3_bucket.S3_website_proyect.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
 
}

