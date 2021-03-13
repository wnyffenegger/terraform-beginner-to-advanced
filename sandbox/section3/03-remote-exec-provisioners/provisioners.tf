provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "../../.aws/credentials"
  profile                 = "default"
}

resource "aws_instance" "myec2" {
    # Declaration of resource to creat
    ami = "ami-09246ddb00c7c4fef"
    instance_type = "t2.micro"
    key_name = "provisioners_rsa"

    # Code to provision resource

    provisioner "remote-exec" {
        inline = [
        "sudo amazon-linux-extras install -y nginx1.12",
        "sudo systemctl start nginx"
        ]

        connection {
            type = "ssh"
            user = "ec2-user"
            private_key = file("./provisioners_rsa.pem")
            host = self.public_ip
        }
    }
}