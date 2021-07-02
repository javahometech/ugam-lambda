resource "aws_s3_bucket" "ugam_feeds" {
  bucket = "ugam-feeds-${terraform.workspace}-bucket"
  acl    = "private"

  tags = {
    Name        = "ugam_feeds"
    Environment = terraform.workspace
  }
}