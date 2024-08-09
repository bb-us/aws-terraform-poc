# Create the S3 buckets
resource "aws_s3_bucket" "images_bucket" {
  bucket = "images-bucket-unique-name"

  tags = {
    Name = "Images Bucket"
  }
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket = "logs-bucket-unique-name"

  tags = {
    Name = "Logs Bucket"
  }
}

# Enable versioning for the S3 buckets
resource "aws_s3_bucket_versioning" "images_versioning" {
  bucket = aws_s3_bucket.images_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "logs_versioning" {
  bucket = aws_s3_bucket.logs_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Define lifecycle configuration for the Images bucket
resource "aws_s3_bucket_lifecycle_configuration" "images_lifecycle" {
  bucket = aws_s3_bucket.images_bucket.bucket

  rule {
    id     = "MoveMemesToGlacier"
    status = "Enabled"

    filter {
      prefix = "memes/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

# Define lifecycle configuration for the Logs bucket
resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs_bucket.bucket

  rule {
    id     = "MoveActiveToGlacier"
    status = "Enabled"

    filter {
      prefix = "active/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "DeleteInactive"
    status = "Enabled"

    filter {
      prefix = "inactive/"
    }

    expiration {
      days = 90
    }
  }
}
