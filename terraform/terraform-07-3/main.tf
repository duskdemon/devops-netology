provider "aws" {
        region = "eu-central-1"
}

locals {
  instance_counte = {
  stage = 1
  prod = 2
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "terr-07-3-bucket-${count.index}-${terraform.workspace}"
  acl    = "private"
  tags = {
    Name        = "Bucket ${count.index}"
    Environment = terraform.workspace
  }
  count = local.instance_counte[terraform.workspace]

  lifecycle {
      create_before_destroy = true
  }
}