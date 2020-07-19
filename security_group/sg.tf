resource "aws_security_group" "security_group" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id != null ? var.vpc_id : null
  revoke_rules_on_delete = var.revoke_rules_on_delete

  # Ingress rule using CIDR block
  dynamic "ingress" {
    for_each = var.ingress_rule_with_cidr_block != [] ? var.ingress_rule_with_cidr_block : null
    
    content {
      self        = ingress.value[0]
      from_port   = ingress.value[1]
      to_port     = ingress.value[2]
      protocol    = ingress.value[3]
      cidr_blocks = ingress.value[4]
      description = try(ingress.value[5], null)
    }
  }

  # Egress rule using CIDR block
  dynamic "egress" {
    for_each = var.egress_rule_with_cidr_block != [] ? var.egress_rule_with_cidr_block : null
    
    content {
      self        = egress.value[0]
      from_port   = egress.value[1]
      to_port     = egress.value[2]
      protocol    = egress.value[3]
      cidr_blocks = egress.value[4]
      description = try(egress.value[5], null)
    }
  }

  # Ingress rule using Security Group ID
  dynamic "ingress" {
    for_each = var.ingress_rule_with_sg_id != [] ? var.ingress_rule_with_sg_id : null
    
    content {
      self            = ingress.value[0]
      from_port       = ingress.value[1]
      to_port         = ingress.value[2]
      protocol        = ingress.value[3]
      security_groups = ingress.value[4]
    }
  }

  # Egress rule using Security Group ID
  dynamic "egress" {
    for_each = var.egress_rule_with_sg_id != [] ? var.egress_rule_with_sg_id : null
    
    content {
      self            = egress.value[0]
      from_port       = egress.value[1]
      to_port         = egress.value[2]
      protocol        = egress.value[3]
      security_groups = egress.value[4]
    }
  }

  # Ingress rule using IPv6 CIDR block
  dynamic "ingress" {
    for_each = var.ingress_rule_with_ipv6 != [] ? var.ingress_rule_with_ipv6 : null
    
    content {
      self            = ingress.value[0]
      from_port       = ingress.value[1]
      to_port         = ingress.value[2]
      protocol        = ingress.value[3]
      ipv6_cidr_blocks = ingress.value[4]
    }
  }

  # Egress rule using IPv6 CIDR block
  dynamic "egress" {
    for_each = var.egress_rule_with_ipv6 != [] ? var.egress_rule_with_ipv6 : null
    
    content {
      self            = egress.value[0]
      from_port       = egress.value[1]
      to_port         = egress.value[2]
      protocol        = egress.value[3]
      ipv6_cidr_blocks = egress.value[4]
    }
  }

  tags = merge(
    {
      Name = lookup(var.tags, "Name", var.name)
    },
    var.tags,
    var.global_tags
  )
}