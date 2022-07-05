resource "aws_lambda_function" "getEmotion" {

  function_name = "ImageEmotionProyecto2022"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 3
  memory_size   = 1024

  s3_bucket = aws_s3_bucket.s3_lambdas.id
  s3_key    = aws_s3_object.getEmotion_zip.key

  source_code_hash = data.archive_file.codeImageEmotion_zip.output_base64sha256

  role = aws_iam_role.face_details_service.arn

  layers = [aws_lambda_layer_version.lambda_layer.arn]

}

resource "aws_lambda_function" "getPlaylist" {

  function_name = "FunctionPlaylistID"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 3
  memory_size   = 1024

  s3_bucket = aws_s3_bucket.s3_lambdas.id
  s3_key    = aws_s3_object.getPlaylist_zip.key

  source_code_hash = data.archive_file.codePlaylistID_zip.output_base64sha256

  role = aws_iam_role.face_details_service.arn

}


