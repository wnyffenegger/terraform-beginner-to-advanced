provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "../../../../.aws/credentials"
  profile                 = "default"
}

module "ec2module" {
    source = "../../modules/ec2"
}