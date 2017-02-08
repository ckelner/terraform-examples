provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"
  name = "kelnerhax"
  cidr = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24"]
  enable_nat_gateway = "false"
  azs = ["us-east-1a"]
  tags {
    "Terraform" = "true"
  }
}

# Our elb security group to access
# the ELB over HTTP
resource "aws_security_group" "elb" {
  name        = "elb_sg-kelnerhax"
  description = "Used in the terraform - kelnerhax"

  vpc_id = "${module.vpc.vpc_id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ensure the VPC has an Internet gateway or this step will fail
  depends_on = ["module.vpc"]
}

resource "aws_elb" "web" {
  name = "example-elb-kelnerhax"

  # The same availability zone as our instance
  subnets = ["${module.vpc.public_subnets[0]}"]

  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.web.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_lb_cookie_stickiness_policy" "default" {
  name                     = "lbpolicy-kelnerhax"
  load_balancer            = "${aws_elb.web.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

resource "aws_security_group" "main_security_group" {
    name = "Kelnerhax-SSH-testing"
    description = "kelnerhax"
    vpc_id = "${module.vpc.vpc_id}"
    // allows traffic from the SG itself for tcp
    ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      self = true
    }
    // allows traffic from the SG itself for udp
    ingress {
      from_port = 0
      to_port = 65535
      protocol = "udp"
      self = true
    }
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web" {
  ami = "${lookup(var.amazon_linux_2016091_HVM_SSD, var.aws_region)}"
  count = "${var.number_of_instances}"
  subnet_id = "${module.vpc.public_subnets[0]}"
  instance_type = "${var.instance_type}"
  tags {
    "Terraform" = "true"
    "Name" = "kelnerhax-testing"
  }
}
