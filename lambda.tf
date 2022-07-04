
resource "aws_lambda_function" "getEmotion" {

  function_name = "ImageEmotionProyecto2022"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 3
  memory_size   = 512

  s3_bucket = aws_s3_bucket.s3_lambdas.id
  s3_key    = aws_s3_object.getEmotion_zip.key

  source_code_hash = data.archive_file.codeImageEmotion_zip.output_base64sha256

  role = aws_iam_role.face_details_service.arn

}
