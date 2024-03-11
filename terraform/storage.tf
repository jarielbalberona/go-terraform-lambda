# Create an S3 bucket
resource "aws_s3_bucket" "silk_dl_datalake_bucket" {
  bucket = "${var.s3_bucket_name}"
}
resource "aws_s3_bucket" "silk_dl_datalake_scripts_bucket" {
  bucket = "${var.s3_bucket_name}-scripts"
}