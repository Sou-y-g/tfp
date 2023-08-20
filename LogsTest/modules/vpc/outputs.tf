output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.log-check-vpc.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.log-check-sub.id
}

output "security_group_id" {
  description = "The ID of the securitygroup"
  value = aws_security_group.log-check-sg.id
}