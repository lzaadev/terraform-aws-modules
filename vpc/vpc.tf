## VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      Name = join("-", [var.name, "vpc"])
    },
    var.default_tags,
    var.global_tags
  )
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = join("-", [var.name, "igw"])
    },
    var.default_tags,
    var.global_tags
  )
}