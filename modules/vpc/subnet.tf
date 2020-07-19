## Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = join("-", "public-subnet", count.index])
      Type = "Public Subnet"
    },
    var.default_tags,
    var.global_tags
  )
}

## Local Route Subnet
resource "aws_subnet" "intra_subnet" {
  count             = length(var.intra_subnets)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.azs[count.index % length(var.azs)]
  cidr_block        = var.intra_subnets[count.index]

  tags = merge(
    {
      Name = join("-", "intra-subnet", count.index])
      Type = "Internal Subnet"
    },
    var.default_tags,
    var.global_tags
  )
}

## Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = merge(
    {
      Name = join("-", "private-subnet", count.index])
      Type = "Private Subnet"
    },
    var.default_tags,
    var.global_tags
  )
}

## Database Subnet
resource "aws_subnet" "db_subnet" {
  count             = length(var.db_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.db_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = merge(
    {
      Name = join("-", "db-subnet", count.index])
      Type = "Database Subnet"
    },
    var.default_tags,
    var.global_tags
  )
}