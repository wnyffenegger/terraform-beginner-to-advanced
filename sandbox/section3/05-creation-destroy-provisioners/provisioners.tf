provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    profile                 = "default"
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH into VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Disable to see how a resource can be marked as tainted  
  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "myec2" {
   ami = "ami-09246ddb00c7c4fef"
   instance_type = "t2.micro"
   key_name = "provisioners_rsa"
   vpc_security_group_ids  = [aws_security_group.allow_ssh.id]

   provisioner "remote-exec" {
     inline = [
       "sudo yum -y install nano"
     ]
   }
   provisioner "remote-exec" {
       when    = destroy
       inline = [
         "sudo yum -y remove nano"
       ]
     }
   connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./provisioners_rsa.pem")
     host = self.public_ip
   }
}