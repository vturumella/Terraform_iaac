output "subnet_public" {
  value = aws_subnet.stratos_subnet_public[0].id
}
output "subnet_private" {
  value = aws_subnet.stratos_subnet_private[0].id
}