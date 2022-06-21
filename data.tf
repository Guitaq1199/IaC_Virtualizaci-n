data "aws_iam_policy_document"  "ima_policy_website_s3"{
    
    statement {
      sid = "AddPerm"
      actions=[
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      principals{
        identifiers = ["*"]
        type        = "AWS"
      }
      resources = [ 
        "${aws_s3_bucket.s3_website.arn}/*" ]
    }
}