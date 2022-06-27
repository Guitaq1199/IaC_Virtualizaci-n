resource "aws_s3_bucket" "S3_for_lambda" {
    bucket = var.bucket_prefix_for_lambda
    force_destroy = true
}
resource "aws_s3_bucket_acl" "Acl_S3_bucket" {
  bucket = aws_s3_bucket.S3_for_lambda.id
  acl = var.acl_lambda_private                                                                      
}