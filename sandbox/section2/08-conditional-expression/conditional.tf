provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    profile                 = "default"
}

variable "istest" {
    default = true
}

resource "aws_instance" "dev" {
    ami = "ami-09246ddb00c7c4fef"
    instance_type = "t2.micro"
    count = var.istest == true ? 1 : 0
}

resource "aws_instance" "prod" {
    ami = "ami-09246ddb00c7c4fef"
    instance_type = "t2.large"
    count = var.istest == false ? 1 : 0
}