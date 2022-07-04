resource "aws_s3_bucket" "S3_website_dynamo" {
    bucket = "dynamomarcelorosales"
    force_destroy = true
}
resource "aws_s3_bucket_acl" "Acl_S3_bucket_Dynamo" {
  bucket = aws_s3_bucket.S3_website_dynamo.id
  acl = "private"
}