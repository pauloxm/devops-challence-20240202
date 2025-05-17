resource "aws_s3_bucket" "devops-challence-20240202-s3-bucket" {
  bucket = "devops-challence-20240202-prxm-remote-state"
}

resource "aws_s3_bucket_versioning" "devops-challence-20240202-s3-bucket-acl-versioning" {
  bucket = aws_s3_bucket.devops-challence-20240202-s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}