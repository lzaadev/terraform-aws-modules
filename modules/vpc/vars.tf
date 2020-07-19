### General Variables ###
variable "project_name" {
  description = "Name of you project. Project name will be added as prefix for Name tag. If not specified, 'tf' will be added."
  type = string
  default = "tf"
}
variable "environment" {
  description = "Environment: prod, staging, uat, qa, dev, test."
  type = string
}
variable "my_ip" {
  description = "Your work, home, internal IP that will be use for example SSH source."
  type = string
  default = ""
}
variable "default_tags" {
  description = "Default tags that are added to every created resource."
  type = map
  default = {
    Terraform = "True"
  }
}
variable "global_tags" {
  description = "Global tags that will be applied to all of the resources created using this module."
  type = map
  default = {}
}

### VPC Variables ###
variable "aws_region" {
  description = "AWS Region"
  type = string
}
variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type = string
}
variable "azs" {
  description = "List of availability zone that will be used."
  type = list
}
variable "enable_dns_support" {
  description = "Enable or disable DNS support in the VPC. Default true."
  type        = bool
  default     = true
}
variable "enable_dns_hostnames" {
  description = "Enable or disable DNS hostname in the VPC. Default true."
  type        = bool
  default     = true
}

### NAT Gateway Variables ###
variable "enable_nat_gateway"{
  description = "Flag whether to create NAT Gateway or not."
  type = bool
  default = false
}

### Subnets Variables ###
variable "public_subnets" {
  description = "Public subnets with route to the Internet and map_public_ip_on_launch set to true."
  type = list
  default = []
}
variable "intra_subnets" {
  description = "Private subnets that have no Internet routing."
  type = list
  default = []
}
variable "private_subnets" {
  description = "Private subnets that have Internet routing through NAT gateway."
  type = list
  default = []
}
variable "db_subnets" {
  description = "Private subnets for database that have Internet routing through NAT gateway."
  type = list
  default = []
}

### NACL Rules Variables ###
variable "public_nacl_rules" {
  description = "Network ACL rules for public subnets."
  type = map
  default = {
    # <rule_no> = [<from_port>, <to_port>, <protocol>, <cidr_block>, <action>],
  }
}
variable "private_nacl_rules" {
  description = "Network ACL rules for private subnets."
  type = map
  default = {
    # <rule_no> = [<from_port>, <to_port>, <protocol>, <cidr_block>, <action>],
  }
}
variable "db_nacl_rules" {
  description = "Network ACL rules for database subnets."
  type = map
  default = {
    # <rule_no> = [<from_port>, <to_port>, <protocol>, <cidr_block>, <action>],
  }
}