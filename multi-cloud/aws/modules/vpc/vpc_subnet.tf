data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "xcloud_subnet" {
  vpc_id     = aws_vpc.xcloud_vpc.id
  count = var.azn_cnt
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = cidrsubnet(var.vpc_cidr,8,count.index)

  tags = {
    Name = "Main"
  }
}
resource "aws_subnet" "xcloud_subnet1" {
  vpc_id     = aws_vpc.xcloud_vpc.id
  count = var.azn_cnt
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = cidrsubnet(var.vpc_cidr,8,count.index)

  tags = {
    Name = "Main"
  }
}
resource "aws_vpc" "xcloud_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_host

  tags = {
    Name = "main"
  }
}
resource "aws_security_group" "xcloud_sg" {
  name        = "xcloud_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.xcloud_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_internet_gateway" "xcloud_gw" {
  vpc_id = aws_vpc.xcloud_vpc.id

  tags = {
    Name = "main"
  }
}
resource "aws_nat_gateway" "xcloud_nat" {
  allocation_id = aws_eip.xcloud_eip.id
  subnet_id     = aws_subnet.xcloud_subnet[0].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.xcloud_gw]
}
resource "aws_route_table" "xcloud_rt" {
  vpc_id = aws_vpc.xcloud_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.xcloud_gw.id
  }

  tags = {
    Name = "example"
  }
}
resource "aws_route_table_association" "xcloud_rta" {
  subnet_id      = aws_subnet.xcloud_subnet[0].id
  route_table_id = aws_route_table.xcloud_rt.id
}
# resource "aws_route_table_association" "xcloud_rtb" {
#   gateway_id     = aws_internet_gateway.xcloud_gw.id
#   route_table_id = aws_route_table.xcloud_rt.id
# }
resource "aws_eip" "xcloud_eip" {
  
}
resource "aws_route" "xcloud_rt" {
  route_table_id            = aws_route_table.xcloud_rt.id
  destination_cidr_block    = var.vpc_cidr
  nat_gateway_id = aws_nat_gateway.xcloud_nat.id
  # vpc_peering_connection_id = "pcx-45ff3dc1"
  # depends_on                = [aws_route_table.testing]
}
