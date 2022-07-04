resource "aws_iam_role" "iam_role_dynamo_lambda" {

  name               = "DynamoRoleLambda"
  assume_role_policy = file("./AssumeRoleLambda.json")
}

resource "aws_iam_role_policy_attachment" "dynamo" {

  role       = aws_iam_role.iam_role_dynamo_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_iam_role_policy_attachment" "S3_Dynamo" {

  role       = aws_iam_role.iam_role_dynamo_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}