provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "../../../../.aws/credentials"
  profile                 = "default"
}

module "ec2module" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "2.17.0"

    name = "my-cluster"
    instance_count = "1"
    ami = "ami-09246ddb00c7c4fef"
    instance_type = "t2.micro"
    subnet_id = "subnet-255c914e"
}