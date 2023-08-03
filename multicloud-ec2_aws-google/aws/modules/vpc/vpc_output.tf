output "vpc_id" {
  value = aws_vpc.xcloud_vpc.id
}
output "subnet_id" {
  value = aws_subnet.xcloud_subnet[0].id
}
output "subnet1_id" {
  value = aws_subnet.xcloud_subnet1[0].id
}