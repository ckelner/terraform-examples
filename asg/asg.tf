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

resource "aws_autoscaling_group" "web-asg" {
  vpc_zone_identifier = ["${module.vpc.public_subnets[0]}"]
  name = "terraform-example-asg-kelnerhax"
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  desired_capacity = "${var.asg_desired}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.web-lc.name}"
  tag {
    key = "Name"
    value = "web-asg-kelnerhax"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "web-lc" {
  name_prefix = "terraform-example-lc-kelnerhax"
  image_id = "${lookup(var.amazon_linux_2016091_HVM_SSD, var.aws_region)}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.main_security_group.id}"]
}
