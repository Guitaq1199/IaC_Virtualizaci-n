data "archive_file" "codeImageEmotion_zip" {

  type        = "zip"
  source_dir  = "./code"
  output_path = "./lambdaCodeEmotion.zip"
}