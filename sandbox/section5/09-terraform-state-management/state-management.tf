provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "../../.aws/credentials"
  profile                 = "default"
}

resource "aws_instance" "webapp" {
  ami           = "ami-09246ddb00c7c4fef"
  instance_type = "t2.micro"
}

resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/system/"
}

terraform {
  backend "s3" {
    bucket = "tform-bucket"
    key    = "state-management.tfstate"
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    dynamodb_table = "s3-state-lock"
  }
}