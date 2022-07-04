data "archive_file" "codeImageEmotion_zip" {

  type        = "zip"
  source_dir  = "./code"
  output_path = "./lambdaCodeEmotion.zip"
}
data "archive_file" "codeLambdaDynamo_zip" {

  type        = "zip"
  source_dir  = "./codeDynamo"
  output_path = "./lambdaDynamo.zip"
}