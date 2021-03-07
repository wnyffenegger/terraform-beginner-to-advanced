provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    profile                 = "default"
}

# resource "aws_iam_user" "lb" {
#     name = var.usernumber
#     path = "/system/"
# }

resource "aws_elb" "bar" {
  name               = var.elb_name
  availability_zones = var.availability_zones
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

#   instances                   = [aws_instance.foo.id]
  cross_zone_load_balancing   = true
  idle_timeout                = var.timeout
  connection_draining         = true
  connection_draining_timeout = var.timeout

  tags = {
    Name = "foobar-terraform-elb"
  }
}