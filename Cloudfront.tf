locals {
  s3_origin_id = "mys3bucketmarcelorosales.com"
}
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "mys3bucketmarcelorosales.com"
}
resource "aws_cloudfront_distribution" "s3_distribution" {
   origin {
    domain_name = aws_s3_bucket.S3_website_proyect.bucket_domain_name
    origin_id   = local.s3_origin_id

   }

  enabled             = true
  ##is_ipv6_enabled     = true
  ##comment             = "my-cloudfront"
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }


 
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "s3_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}