provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    profile                 = "default"
}

resource "aws_instance" "myec2" {
    ami = "ami-09246ddb00c7c4fef"
    instance_type = var.list[0]
}

variable "list" {
    type = list
    default = ["m5.large", "m5.xlarge", "t2.medium"]
}

variable "types" {
    type = map
    default = {
        us-east-1 = "t2.micro"
        us-west-2 = "t2.nano"
        ap-south-1 = "t2.small"
    }
}
