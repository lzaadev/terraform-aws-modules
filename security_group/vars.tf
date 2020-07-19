# General Variables
variable "tags" {
  description = "Default tags that are added to every created resource."
  type = map
  default = {}
}

variable "global_tags" {
  description = "Global tags that will be applied to all of the resources created using this module."
  type = map
  default = {
    Terraform = "True"
  }
}

# Resource related variables
variable "name" {
  description = "Security group name."
  type = string
}

variable "description" {
  description = "Security group description."
  type = string
}

variable "vpc_id" {
  description = "The VPC ID this security group will be created."
  type = string
  default = ""
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself."
  type = bool
  default = false
}

variable "ingress_rule_with_cidr_block" {
  description = "List of Ingress rules using IPv4 cidr blocks."
  type = list
  default = []
}

variable "egress_rule_with_cidr_block" {
  description = "List of Egress rules using IPv4 cidr blocks."
  type = list
  default = []
}

variable "ingress_rule_with_sg_id" {
  description = "List of Ingress rules using security group ID."
  type = list
  default = []
}

variable "egress_rule_with_sg_id" {
  description = "List of Egress rules using security group ID."
  type = list
  default = []
}

variable "ingress_rule_with_ipv6" {
  description = "List of Ingress rules using IPv6 cidr block."
  type = list
  default = []
}

variable "egress_rule_with_ipv6" {
  description = "List of Egress rules using IPv6 cidr block."
  type = list
  default = []
}