variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default     = "us-east-1a"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}

variable "amazon_linux_2016091_HVM_SSD" {
  default = {
    us-east-1 = "ami-9be6f38c" # US East (N. Virginia)
    us-east-2 = "ami-38cd975d" # US East (Ohio)
    us-west-1 = "ami-b73d6cd7" # US West (N. California)
    us-west-2 = "ami-1e299d7e" # US West (Oregon)
    ca-central-1 = "ami-eb20928f" # Canada (Central)
    eu-west-1 = "ami-c51e3eb6" # EU (Ireland)
    eu-west-2 = "ami-bfe0eadb" # EU (London)
    eu-central-1 = "ami-211ada4e" # EU (Frankfurt)
    ap-southeast-1 = "ami-4dd6782e" # Asia Pacific (Singapore)
    ap-southeast-2 = "ami-28cff44b" # Asia Pacific (Sydney)
    ap-northeast-1 = "ami-9f0c67f8" # Asia Pacific (Tokyo)
    ap-northeast-2 = "ami-94bb6dfa" # Asia Pacific (Seoul)
    ap-south-1 = "ami-9fc7b0f0" # Asia Pacific (Mumbai)
    sa-east-1 = "ami-bb40d8d7" # South America (São Paulo)
  }
}

variable "amis_community_ubuntu_1604LTS_HVM_SSD" {
  default = {
    us-east-1 = "ami-6edd3078"
    us-west-2 = "ami-7c803d1c"
    us-west-1 = "ami-539ac933"
    eu-central-1 = "ami-5aee2235"
    eu-west-1 = "ami-d8f4deab"
    ap-southeast-1 = "ami-b1943fd2"
    ap-southeast-2 = "ami-fe71759d"
    ap-northeast-1 = "ami-eb49358c"
    sa-east-1 = "ami-7379e31f"
  }
}

variable "number_of_instances" {
  default = "1"
}

variable "instance_type" {
  default = "t2.micro"
}
