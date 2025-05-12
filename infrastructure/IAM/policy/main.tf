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

resource "aws_s3_bucket" "example"{
  bucket = "bucket-tf-aim-policy"
  tags = {
    Environment=local.environment_name
  }
}