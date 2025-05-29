provider "aws" {
  region = "us-east-2"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-demo-static-site-${random_id.suffix.hex}"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name        = "Demo Static Website"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

output "website_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}