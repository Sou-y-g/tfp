output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public1_id" {
  value = aws_subnet.public1.id
}

output "public2_id" {
  value = aws_subnet.public2.id
}
