provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "../../.aws/credentials"
  profile                 = "default"
}

resource "aws_instance" "myec2" {
   ami = "ami-09246ddb00c7c4fef"
   instance_type = lookup(var.instance_type, terraform.workspace)
}

variable "instance_type" {
    type = map
    default = {
        default = "t2.nano"
        dev = "t2.micro"
        prod = "t2.large"
    }
}