resource "aws_s3_bucket" "S3_website_dynamo" {
    bucket = var.bucket_prefix_lambda_Dynamo
    force_destroy = true
}
resource "aws_s3_bucket_acl" "Acl_S3_bucket_Dynamo" {
  bucket = aws_s3_bucket.S3_website_dynamo.id
  acl = "private"
}
resource "aws_s3_object" "dynamocode_zip" {

  bucket = aws_s3_bucket.S3_website_dynamo.id
  key    = "lambda_dynamo.zip"
  source = data.archive_file.codeLambdaDynamo_zip.output_path
  etag = filemd5(data.archive_file.codeLambdaDynamo_zip.output_path)
}