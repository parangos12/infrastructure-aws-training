terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
locals {
  environment_name = terraform.workspace
}
provider "aws" {
  region     = "us-east-1"
  access_key = var.ACCESS_KEY
  secret_key = var.SECRET_KEY
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "epam-trainning-tf-states"

  tags = {
    env  = terraform.workspace
    Name = format("%s-%s", "epam-trainning-tf-states", terraform.workspace)
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "epam-training-terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    env = terraform.workspace
  }
}