output "id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "cidr_block" {
  description = "VPC ID"
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnets" {
  value = [ for subnet in aws_subnet.public_subnet: subnet ]
} 
output "public_subnet" {
  value = [ for subnet in aws_subnet.public_subnet: subnet ]
} 

output "private_subnets" {
  value = [ for subnet in aws_subnet.private_subnet: subnet ]
} 
output "private_subnet" {
  value = [ for subnet in aws_subnet.private_subnet: subnet ]
}

output "db_subnets" {
  value = [ for subnet in aws_subnet.db_subnet: subnet ]
} 
output "db_subnet" {
  value = [ for subnet in aws_subnet.db_subnet: subnet ]
} 

output "nat_subnet" {
  value = var.enable_nat_instance ? aws_subnet.nat_subnet[0] : null
}