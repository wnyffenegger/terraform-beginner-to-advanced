provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    profile                 = "default"
}

# resource "aws_instance" "counting" {
#     ami = "ami-09246ddb00c7c4fef"
#     instance_type = "t2.micro"
#     count = 3
# }

variable "elb_names" {
    type = list
    default = ["dev-lb", "stage-lb", "prod-lb"]
}

resource "aws_iam_user" "lb" {
    name = var.elb_names[count.index]
    path = "/system/"
    count = 3
}