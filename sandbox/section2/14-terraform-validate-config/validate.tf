provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "../../.aws/credentials"
  profile                 = "default"
}

# Comment out terraform will discover missing var
variable instancetype {
    default = "t2.micro"
}

resource "aws_instance" "myec2" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = var.instancetype
  sky           = "blue"
}