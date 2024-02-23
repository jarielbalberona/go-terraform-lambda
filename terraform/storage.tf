# Create an S3 bucket
resource "aws_s3_bucket" "datalake_bucket" {
  bucket = "${var.project}"
}