# Only one set of required providers in a dir
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=2.46.0"
#     }
#     github = {
#       source = "integrations/github"
#       version = "4.5.1"
#     }
#   }
# }

provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    profile                 = "default"
}

resource "aws_instance" "myec2" {
    ami = "ami-09246ddb00c7c4fef"
    instance_type = "t2.micro"
}
