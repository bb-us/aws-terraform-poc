resource "aws_s3_bucket" "images" {
  bucket = "images"
}

resource "aws_s3_bucket_lifecycle_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    id      = "archive"
    status  = "Enabled"
    filter {
      prefix = "archive/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "logs"
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id      = "active"
    status  = "Enabled"

    filter {
      prefix = "active/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id      = "inactive"
    status  = "Enabled"

    filter {
      prefix = "Inactive/"
    }

    expiration {
      days = 90
    }
  }
}
