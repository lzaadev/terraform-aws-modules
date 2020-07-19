resource "aws_instance" "nat_instance" {
  count             = var.enable_nat_instance ? 1 : 0
  ami               = lookup(var.nat_instance_ami, var.aws_region)
  instance_type     = var.nat_instance_type
  subnet_id         = aws_subnet.nat_subnet[count.index].id
  source_dest_check = false
  vpc_security_group_ids = [aws_security_group.nat_instance_sg[count.index].id]

  tags = merge(
    {
      Name  = join("-", [var.name, "nat-instance"])
      Type = "NAT Instance"
    },
    var.default_tags,
    var.global_tags
  )
}

resource "aws_security_group" "nat_instance_sg" {
  count       = var.enable_nat_instance ? 1 : 0
  name        = "nat_instance_sg"
  description = "NAT Instance security group."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  dynamic "egress" {
    for_each = var.nat_instance_sg_outbound

    content {
      from_port   = egress.value[0]
      to_port     = egress.value[1]
      protocol    = egress.value[2]
      cidr_blocks = egress.value[3]
    }
  }

  tags = merge(
    {
      Name  = join("-", [var.name, "nat-instance-sg"])
      Type = "NAT Instance"
    },
    var.default_tags,
    var.global_tags
  )
}

## NAT Instance Subnet
resource "aws_subnet" "nat_subnet" {
  count                   = var.enable_nat_instance && var.nat_subnet != "" ? 1 : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.nat_subnet
  availability_zone       = var.nat_az != "" ? var.nat_az : var.azs[0]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name  = join("-", [var.name, "nat-instance-subnet"])
      Type = "NAT Instance"
    },
    var.default_tags,
    var.global_tags
  )
}

## NAT Network ACL
resource "aws_network_acl" "nat_nacl" {
  count      = var.enable_nat_instance ? 1 : 0
  vpc_id     = aws_vpc.vpc.id
# subnet_ids = [ for subnet in aws_subnet.nat_subnet: subnet.id ]
  subnet_ids = [aws_subnet.nat_subnet[count.index].id]

  dynamic "ingress" {
    for_each = var.nat_nacl_rules

    content {
      rule_no    = ingress.key
      from_port  = ingress.value[0]
      to_port    = ingress.value[1]
      protocol   = ingress.value[2]
      cidr_block = ingress.value[3]
      action     = ingress.value[4]
    }
  }

  dynamic "egress" {
    for_each = var.nat_nacl_rules

    content {
      rule_no    = egress.key
      from_port  = egress.value[0]
      to_port    = egress.value[1]
      protocol   = egress.value[2]
      cidr_block = egress.value[3]
      action     = egress.value[4]
    }
  }

  tags = merge(
    {
      Name  = join("-", [var.name, "nat-instance-nacl"])
      Type = "NAT Instance"
    },
    var.default_tags,
    var.global_tags
  )
}

resource "aws_route_table_association" "nat_rtbassoc" {
  count          = var.enable_nat_instance ? 1 : 0
  route_table_id = join("", aws_route_table.ext_route_table.*.id)
  subnet_id      = aws_subnet.nat_subnet[count.index].id
}