data "archive_file" "codeImageEmotion_zip" {

  type        = "zip"
  source_dir  = "./code"
  output_path = "./lambdaCodeEmotion.zip"
}

data "archive_file" "codePlaylistID_zip" {

  type        = "zip"
  source_dir  = "./functionPlaylist"
  output_path = "./lambdaCodePlaylistID.zip"
}