# resource "aws_s3_bucket_object" "index_page" {
#   bucket = aws_s3_bucket.bucket.id
#   key = "index.html"
#   source = "../../../my-app/out"
#   content_type = "text/html"
#   etag = filemd5("../../../my-app/out/index.html")
# }