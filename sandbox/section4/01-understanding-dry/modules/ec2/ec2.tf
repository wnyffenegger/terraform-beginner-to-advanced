resource "aws_instance" "myec2" {
   ami = "ami-09246ddb00c7c4fef"
   instance_type = "t2.small"
}
