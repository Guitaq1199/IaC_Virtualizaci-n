
resource "aws_api_gateway_rest_api" "apigateway"{
    name = "APIUploadImage"
    description = "API Gateway para Imagen"

    binary_media_types = [ 
    "image/jpeg",
    "image/png",
    "application/json"
  ]
}

resource "aws_api_gateway_resource" "image_upload" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part = "upload"
}

resource "aws_api_gateway_resource" "playlist_ID" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part = "playlist"
}


//PENDIENTE
resource "aws_api_gateway_deployment" "api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigateway.id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.apigateway.body))
  }

  depends_on = [
    aws_api_gateway_integration.lambda_getEmotion,
    aws_api_gateway_integration.ImageDetails_cors,
    aws_api_gateway_integration.lambda_getPlaylist,
  ]
}

resource "aws_api_gateway_stage" "api_gwStage" {

  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  stage_name    = "v1"
}

resource "aws_api_gateway_request_validator" "validator_request" {
  name                        = "Validate query string parameters and headers"
  rest_api_id                 = aws_api_gateway_rest_api.apigateway.id
  validate_request_body       = false
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "ImageDetails_post" {

  rest_api_id      = aws_api_gateway_rest_api.apigateway.id
  resource_id      = aws_api_gateway_resource.image_upload.id
  api_key_required = false
  http_method      = "POST"
  authorization    = "NONE"
  request_parameters = {"method.request.querystring.file" = true}
  request_validator_id = aws_api_gateway_request_validator.validator_request.id
}

resource "aws_api_gateway_method" "playlist_get" {

  rest_api_id      = aws_api_gateway_rest_api.apigateway.id
  resource_id      = aws_api_gateway_resource.playlist_ID.id
  api_key_required = false
  http_method      = "GET"
  authorization    = "NONE"
  request_parameters = {"method.request.querystring.name" = true}
  //request_validator_id = aws_api_gateway_request_validator.validator_request.id
}

resource "aws_api_gateway_method_response" "ImageDetails_post_response_200" {

  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.image_upload.id
  http_method = aws_api_gateway_method.ImageDetails_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "PlaylistDetails_post_response_200" {

  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.playlist_ID.id
  http_method = aws_api_gateway_method.playlist_get.http_method
  status_code = "200"

  /*
  response_models = {
    "application/json" = "Empty"
  }*/

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "lambda_getEmotion" {

  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  resource_id             = aws_api_gateway_resource.image_upload.id
  http_method             = aws_api_gateway_method.ImageDetails_post.http_method
  integration_http_method = aws_api_gateway_method.ImageDetails_post.http_method

  uri = aws_lambda_function.getEmotion.invoke_arn

  type                 = "AWS"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_TEMPLATES"

  request_templates = {
    "image/jpeg"       = "{\"name\": \"$input.params('file')\", \"content\": \"$input.body\"}",
    "image/png"        = "{\"name\": \"$input.params('file')\", \"content\": \"$input.body\"}",
    "application/json" = "{\"name\": \"$input.params('file')\", \"content\": \"$input.body\"}"
  }
}

resource "aws_api_gateway_integration" "lambda_getPlaylist" {

  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  resource_id             = aws_api_gateway_resource.playlist_ID.id
  http_method             = aws_api_gateway_method.playlist_get.http_method
  integration_http_method = "POST"

  uri = aws_lambda_function.getPlaylist.invoke_arn

  type                 = "AWS"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  content_handling     = "CONVERT_TO_TEXT"

  request_templates = {
    "application/json" = "{\"name\": \"$input.params('name')\"}"
  }

}


resource "aws_api_gateway_integration_response" "lambda_getEmotion" {

  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.image_upload.id
  http_method = aws_api_gateway_method.ImageDetails_post.http_method
  status_code = aws_api_gateway_method_response.ImageDetails_post_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.lambda_getEmotion
  ]
}


resource "aws_api_gateway_integration_response" "lambda_getPlaylist" {

  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.playlist_ID.id
  http_method = aws_api_gateway_method.playlist_get.http_method
  status_code = aws_api_gateway_method_response.PlaylistDetails_post_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.lambda_getPlaylist
  ]
}

resource "aws_lambda_permission" "api_gw_Emotion" {

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getEmotion.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apigateway.execution_arn}/*/${aws_api_gateway_method.ImageDetails_post.http_method}/${aws_api_gateway_resource.image_upload.path_part}"

}

resource "aws_lambda_permission" "api_gw_Playlist" {

  //statement_id  = "AllowAPIGatewayInvoke"
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getPlaylist.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apigateway.execution_arn}/*/${aws_api_gateway_method.playlist_get.http_method}/${aws_api_gateway_resource.playlist_ID.path_part}"

}


resource "aws_api_gateway_method" "ImageDetails_cors" {

  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.image_upload.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "ImageDetails_cors_response_200" {

  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.image_upload.id
  http_method = aws_api_gateway_method.ImageDetails_cors.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "ImageDetails_cors" {

  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.image_upload.id
  http_method = aws_api_gateway_method.ImageDetails_cors.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{'statusCode': 200}"
  }
}

resource "aws_api_gateway_integration_response" "ImageDetails_cors" {

  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.image_upload.id
  http_method = aws_api_gateway_method.ImageDetails_cors.http_method
  status_code = aws_api_gateway_method_response.ImageDetails_cors_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,PATCH,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.ImageDetails_cors
  ]
}
