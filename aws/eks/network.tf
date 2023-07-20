/* 
Create AWS VPC (Virtual Private Cloud).
Create two public and two private Subnets in different availability zones.
Create Internet Gateway to provide internet access for services within VPC.
Create NAT Gateway in public subnets. It is used in private subnets to allow services to connect to the internet.
Create Routing Tables and associate subnets with them. Add required routing rules.
Create Security Groups and associate subnets with them. Add required routing rules. */

resource "aws_vpc" "eks_vpc" {
  enable_dns_support   = var.dns_supp
  enable_dns_hostnames = var.dns_host
  cidr_block           = var.vpc_cidr
  tags = {
    Name = "eks-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  count             = var.az_zone_cnt
  vpc_id            = aws_vpc.eks_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)

  map_public_ip_on_launch = true
}

output "public" {
  value = aws_subnet.public_subnet
}

resource "aws_subnet" "private_subnet" {
  count             = var.az_zone_cnt
  vpc_id            = aws_vpc.eks_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.az_zone_cnt)
}
output "private" {
  value = aws_subnet.private_subnet
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks cluster vpc"
  }
}
resource "aws_eip" "eks_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eks_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    name = "nat gatway"
  }

}

resource "aws_route_table" "eks_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "a" {
  count          = var.az_zone_cnt
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.eks_rt.id
}

resource "aws_route" "r" {
  route_table_id         = aws_route_table.eks_rt.id
  gateway_id             = aws_nat_gateway.ngw.id
  destination_cidr_block = "172.0.0.0/12"
}

resource "aws_security_group" "eks_subnet_sg" {
  name        = "eks_test"
  description = "security group for public subnetsc"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description = "eks from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
    /* ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block] */
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
    /* ipv6_cidr_blocks = ["::/0"] */
  }

  tags = {
    Name = "eks cluster sg"
  }
}

