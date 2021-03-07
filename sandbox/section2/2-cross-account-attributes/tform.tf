provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    profile                 = "default"
}

resource "aws_instance" "myec2" {
    ami = "ami-09246ddb00c7c4fef"
    instance_type = "t2.micro"
}

resource "aws_eip" "lb" {
  vpc      = true
}

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.myec2.id
#   allocation_id = aws_eip.lb.id
# }

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.myec2.id}"
  allocation_id = "${aws_eip.lb.id}"
}


resource "aws_security_group" "allow_tls" {
    name        = "wnyffenegger-test-sg"
    description = "Allow TLS inbound traffic"

    ingress {
      description = "TLS from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["${aws_eip.lb.public_ip}/32"]

      # Does not work must be range
      # cidr_blocks = [aws_eip.lb.public_ip/32]
    }
}
