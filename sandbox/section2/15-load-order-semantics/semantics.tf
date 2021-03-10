# provider "aws" {
#   region                  = "us-east-2"
#   shared_credentials_file = "../../.aws/credentials"
#   profile                 = "default"
# }

# variable "iam_user" {
#   default = "demouser"
# }

# resource "aws_instance" "myec2" {
#    ami = "ami-082b5a644766e0e6f"
#    instance_type = "t2.micro"
# }

# resource "aws_iam_user" "lb" {
#   name = var.iam_user
#   path = "/system/"
# }