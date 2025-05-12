terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
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

//1. Create a TRUST RELATIONSHIP policy document.
data "aws_iam_policy_document" "assume_role_doc" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

//2. Create the role with the TRUST RELATIONSHIP allowing the EC2 service to assume the role.
//The 'assume_role_policy' attribute contains a JSON Policy document.
resource "aws_iam_role" "demo_role" {
  name               = "demo_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
}

//3. Attach IAM Policy 'AmazonS3FullAccess' to above role.
resource "aws_iam_role_policy_attachment" "s3_full_access_att" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.demo_role.name
}

//4. Create a IAM instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "demo_profile"
  role = aws_iam_role.demo_role.name
}

//5. Create an EC2 Instance
resource "aws_instance" "demo_instance" {
  ami           = "ami-0f88e80871fd81e91"
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "demo_instance"
  }
}














