data "archive_file" "codeLambdaDynamo_zip" {

  type        = "zip"
  source_dir  = "./codeDynamo"
  output_path = "./lambdaDynamo.zip"
}