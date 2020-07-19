### NAT Instance Variables ###
variable "enable_nat_instance"{
  description = "Flag whether to create NAT Instance or not."
  type = bool
  default = false
}

variable "nat_subnet" {
  description = "The VPC subnet the NAT instance will launch in. If not specified, public_subnets[0] will be used."
  type = string
  default = ""
}

variable "nat_instance_ami" {
  description = "AWS AMI ID for NAT Instance."
  type = map
  default = {
    ap-southeast-1 = "ami-0003ce8d47722ef67"
    ap-southeast-2 = "ami-00c1445796bc0a29f"
  }
}

variable "nat_az" {
  description = "Availability zone where the NAT instance will be deployed. Random if not specified."
  type = string
  default = ""
}

variable "nat_instance_type" {
  description = "Instance type of the NAT instance."
  type = string
  default = "t2.micro"
}

variable "nat_instance_sg_outbound" {
  description = "NAT Instance security group - outbound."
  type = list
  default = [
    #<from>, <to>, <protocol>, <cidr>
    [80, 80, "tcp", ["0.0.0.0/0"]],
    [443, 443, "tcp", ["0.0.0.0/0"]],
    [1024, 65535, "tcp", ["0.0.0.0/0"]],
  ]
}

variable "nat_nacl_rules" {
  description = "Network ACL rules for public subnets."
  type = map
  default = {
    # <rule_no> = [<from_port>, <to_port>, <protocol>, <cidr_block>, <action>],
    100 = [80, 80, "tcp", "0.0.0.0/0", "allow"],
    200 = [443, 443, "tcp", "0.0.0.0/0", "allow"],
    300 = [1024, 65535, "tcp", "0.0.0.0/0", "allow"],
  }
}