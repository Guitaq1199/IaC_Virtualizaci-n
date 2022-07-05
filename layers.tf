resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "./requests.zip"
  layer_name = "request_library"

  compatible_runtimes = ["python3.6" , "python3.7" , "python3.8" , "python3.9"]
}