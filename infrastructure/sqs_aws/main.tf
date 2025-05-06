terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version="5.97.0"
    }
  }
  backend "s3" {
    bucket         = "epam-trainning-tf-states"
    key            = "dev/sqs/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = false
    dynamodb_table = "epam-training-terraform-lock-table"
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

resource "aws_sqs_queue" "sqs-queue" {
  name                      = "workflow-item"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = terraform.workspace
  }
}
