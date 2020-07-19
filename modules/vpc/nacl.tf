## Default VPC NACL (Main)
resource "aws_default_network_acl" "default_nacl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name = "default-nacl"
      Type = "Default NACL"
    },
    var.default_tags,
    var.global_tags
  )
} 

## NACL for Public Subnets
resource "aws_network_acl" "public_nacl" {
  # If there is no rule specified, NACL will not be created
  count      = length(var.public_nacl_rules) == 0 ? 0 : 1
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [ for subnet in aws_subnet.public_subnet: subnet.id ]

  dynamic "ingress" {
    for_each = var.public_nacl_rules

    content { 
      rule_no    = ingress.key
      from_port  = ingress.value[0]
      to_port    = ingress.value[1]
      protocol   = ingress.value[2]
      cidr_block = ingress.value[3]
      action     = ingress.value[4]

      icmp_type  = ingress.value[2] == "icmp" ? ingress.value[0] : null
      icmp_code  = ingress.value[2] == "icmp" ? ingress.value[1] : null
    }
  }

  dynamic "egress" {
    for_each = var.public_nacl_rules

    content {
      rule_no    = egress.key
      from_port  = egress.value[0]
      to_port    = egress.value[1]
      protocol   = egress.value[2]
      cidr_block = egress.value[3]
      action     = egress.value[4]

      icmp_type  = egress.value[2] == "icmp" ? egress.value[0] : null
      icmp_code  = egress.value[2] == "icmp" ? egress.value[1] : null
    }
  }

  tags = merge(
    {
      Name = "public-nacl"
      Type = "Public NACL"
    },
    var.default_tags,
    var.global_tags
  )
}

## NACL for Private Subnets
resource "aws_network_acl" "private_nacl" {
  # If there is no rule specified, NACL will not be created
  count      = length(var.private_nacl_rules) == 0 ? 0 : 1
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [ for subnet in aws_subnet.private_subnet: subnet.id ]

  dynamic "ingress" {
    for_each = var.private_nacl_rules

    content {
      rule_no    = ingress.key
      from_port  = ingress.value[0]
      to_port    = ingress.value[1]
      protocol   = ingress.value[2]
      cidr_block = ingress.value[3]
      action     = ingress.value[4]

      icmp_type  = ingress.value[2] == "icmp" ? ingress.value[0] : null
      icmp_code  = ingress.value[2] == "icmp" ? ingress.value[1] : null
    }
  }

  dynamic "egress" {
    for_each = var.private_nacl_rules

    content {
      rule_no    = egress.key
      from_port  = egress.value[0]
      to_port    = egress.value[1]
      protocol   = egress.value[2]
      cidr_block = egress.value[3]
      action     = egress.value[4]

      icmp_type  = egress.value[2] == "icmp" ? egress.value[0] : null
      icmp_code  = egress.value[2] == "icmp" ? egress.value[1] : null
    }
  }

  tags = merge(
    {
      Name = "private-nacl"
      Type = "Private NACL"
    },
    var.default_tags,
    var.global_tags
  )
}

## NACL for Database Subnets
resource "aws_network_acl" "db_nacl" {
  # If there is no rule specified, NACL will not be created
  count      = length(var.db_nacl_rules) == 0 ? 0 : 1
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [ for subnet in aws_subnet.db_subnet: subnet.id ]

  dynamic "ingress" {
    for_each = var.db_nacl_rules

    content {
      rule_no    = ingress.key
      from_port  = ingress.value[0]
      to_port    = ingress.value[1]
      protocol   = ingress.value[2]
      cidr_block = ingress.value[3]
      action     = ingress.value[4]

      icmp_type  = ingress.value[2] == "icmp" ? ingress.value[0] : null
      icmp_code  = ingress.value[2] == "icmp" ? ingress.value[1] : null
    }
  }

  dynamic "egress" {
    for_each = var.db_nacl_rules

    content {
      rule_no    = egress.key
      from_port  = egress.value[0]
      to_port    = egress.value[1]
      protocol   = egress.value[2]
      cidr_block = egress.value[3]
      action     = egress.value[4]

      icmp_type  = egress.value[2] == "icmp" ? egress.value[0] : null
      icmp_code  = egress.value[2] == "icmp" ? egress.value[1] : null
    }
  }

  tags = merge(
    {
      Name = "database-nacl"
      Type = "Database NACL"
    },
    var.default_tags,
    var.global_tags
  )
}