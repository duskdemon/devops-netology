provider "aws" {
        region = "eu-central-1"
}

locals {
  foreach_buckets = toset([
    "4-1",
    "4-2",
  ])
}
resource "aws_s3_bucket" "terr-07-3-4" {
  for_each = local.foreach_buckets
  bucket = "terr-07-3-${each.key}-${terraform.workspace}"
  acl    = "private"
  tags = {
    Name        = "Bucket-07-3-4 ${each.key}"
    Environment = terraform.workspace
  }
  lifecycle {
      create_before_destroy = true
  }
}