output "id" {
  value = aws_security_group.security_group.id
}

output "name" {
  value = aws_security_group.security_group.name
}

output "arn" {
  value = aws_security_group.security_group.arn
}

output "ingress" {
  value = aws_security_group.security_group.ingress
}

output "egress" {
  value = aws_security_group.security_group.egress
}