resource "aws_lambda_function" "lambda_dynamo_procesor" {

  function_name = "SongRecomedationProcesor"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.6"
  timeout       = 3
  memory_size   = 512

  s3_bucket = aws_s3_bucket.S3_website_dynamo.id
  s3_key    = aws_s3_object.dynamocode_zip.key

  source_code_hash = data.archive_file.codeLambdaDynamo_zip.output_base64sha256

  role = aws_iam_role.iam_role_dynamo_lambda.arn

}
