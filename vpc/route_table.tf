## VPC's default route table (main) # Local Route
resource "aws_default_route_table" "default_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = merge(
    {
      Name  = join("-", [var.name, "local-route-table"])
      Route = "Local"
    },
    var.default_tags,
    var.global_tags
  )
}

# Zero-or-one Resource
# https://github.com/hashicorp/terraform/issues/2831#issuecomment-298751019

## External Route Table
resource "aws_route_table" "ext_route_table" {
  # If there are no public subnets, external route table will not be created
  count  = length(var.public_subnets) == 0 ? 0 : 1
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      Name  = join("-", [var.name, "igw-route-table"])
      Route = "Internet Gateway"
    },
    var.default_tags,
    var.global_tags
  )
}

## Internal Route Table
resource "aws_route_table" "int_route_table" {
  # If NAT Gateway is true, route table for NAT gateway will be created.
  count       = var.enable_nat_gateway || var.enable_nat_instance || length(var.private_subnets) != 0 ? 1 : 0
  vpc_id      = aws_vpc.vpc.id
   
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = var.enable_nat_instance ? aws_instance.nat_instance[count.index].id : null
  }

  tags = merge(
    {
      Name  = join("-", [var.name, "nat-route-table"])
      Route = "NAT Gateway"
    },
    var.default_tags,
    var.global_tags
  )
}

#--- Associate Subnet to respective Route Tables ---#

## Associate Public Subnets to External Route Table
resource "aws_route_table_association" "ext_rt_assoc" {
  count = length(var.public_subnets)
  route_table_id = join("", aws_route_table.ext_route_table.*.id)
  subnet_id = aws_subnet.public_subnet[count.index].id
}

## Associate Private Subnets to Internal Route Table
resource "aws_route_table_association" "ps_int_rt_assoc" {
  count = length(var.private_subnets)
  route_table_id = join("", aws_route_table.int_route_table.*.id)
  subnet_id = aws_subnet.private_subnet[count.index].id
}

## Associate Database Subnets to Internal Route Table
resource "aws_route_table_association" "dbs_int_rt_assoc" {
  count = length(var.db_subnets)
  route_table_id = join("", aws_route_table.int_route_table.*.id)
  subnet_id = aws_subnet.db_subnet[count.index].id
}

## Associate Intra Subnets to Local (Default) Route Table
resource "aws_route_table_association" "intra_rt_assoc" {
  count = length(var.intra_subnets)
  route_table_id = aws_default_route_table.default_rt.id
  subnet_id = aws_subnet.intra_subnet[count.index].id
}