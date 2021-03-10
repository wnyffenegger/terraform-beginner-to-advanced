provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "../../.aws/credentials"
  profile                 = "default"
}

resource "aws_instance" "myec2" {
   ami = "ami-09246ddb00c7c4fef"
   instance_type = "t2.micro"
}