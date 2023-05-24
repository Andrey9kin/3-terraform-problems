data "aws_caller_identity" "current" {}

locals {
  state_bucket_name = format("infra-state-%s", sha1(data.aws_caller_identity.current.account_id))
  logs_bucket_name  = format("access-logs-%s", sha1(data.aws_caller_identity.current.account_id))
}

resource "aws_s3_account_public_access_block" "block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "state_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"

  bucket = local.state_bucket_name

  versioning = {
    enabled = true
  }

  logging = {
    target_bucket = module.logs_bucket.s3_bucket_id
    target_prefix = format("%s/", local.state_bucket_name)
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

module "logs_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"

  bucket = local.logs_bucket_name

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}