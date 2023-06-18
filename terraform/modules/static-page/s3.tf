resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "static-www"
  acl = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  } 
}

resource "aws_s3_bucket_policy" "bucket" {
    bucket = aws_s3_bucket.bucket.id
    policy = data.aws_iam_policy_document.static-www.json
}

data "aws_iam_policy_document" "static-www" {
  statement {
    sid = "Allow CloudFront"
    effect = "Allow"
    principals {
        type = "AWS"
        identifiers = [aws_cloudfront_origin_access_identity.static-www.iam_arn]
    }
    actions = [
        "s3:GetObject"
    ]

    resources = [
        "${aws_s3_bucket.bucket.arn}/*"
    ]
  }
}