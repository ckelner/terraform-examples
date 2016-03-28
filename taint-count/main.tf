variable "project_aws_access_key" {}
variable "project_aws_secret_key" {}

provider "aws" {
  access_key = "${var.project_aws_access_key}"
  secret_key = "${var.project_aws_secret_key}"
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.1.0/28"
  tags {
    Name = "count-example"
  }
}

resource "aws_security_group" "count-example" {
  count = 4

  name = "count-example-${count.index}"
  description = "count-example"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/32" ]
  }
}
