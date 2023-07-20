data "aws_vpc" "new_vpc" {
  id = aws_vpc.new_vpc.id

}

data "aws_subnets" "subnet_1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.new_vpc.id]
  }
}
resource "aws_subnet" "subnet_1" {

  vpc_id            = aws_vpc.new_vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = cidrsubnet(aws_vpc.new_vpc.cidr_block, 4, 1)
}
output "name1" {
  value = data.aws_subnets.subnet_1
}
data "aws_subnets" "subnet_2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.new_vpc.id]
  }
}
resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.new_vpc.id
  availability_zone = "us-east-1f"
  cidr_block        = cidrsubnet(aws_vpc.new_vpc.cidr_block, 4, 2)
}

output "name" {
  value = data.aws_subnets.subnet_2

}

