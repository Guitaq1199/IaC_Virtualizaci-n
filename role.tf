//Lambda's roles

// Face details role
resource "aws_iam_role" "face_details_service" {

  name               = "RolRekognitionImageProyecto2022"
  assume_role_policy = file("./AssumeRoleLambda.json")
}

resource "aws_iam_role_policy_attachment" "ExecutionRole" {

  role       = aws_iam_role.face_details_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "Rekognition" {

  role       = aws_iam_role.face_details_service.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "S3" {

  role       = aws_iam_role.face_details_service.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}