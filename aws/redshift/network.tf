/* Create a VPC, Subnets, and other network components
Create a VPC Default Security Group */

resource "aws_vpc" "rs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.dns_host
  enable_dns_support   = var.dns_supp

  tags = {
    Name = "main"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "rs_subnet" {
  count             = var.az_zone_cnt
  vpc_id            = aws_vpc.rs_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Main"
  }
}
resource "aws_redshift_subnet_group" "rs_sub_grp" {
  name       = "rs-group"
  subnet_ids = flatten([aws_subnet.rs_subnet[*].id])

  tags = {
    environment = "test"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.rs_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "redshift_rt" {

  vpc_id = aws_vpc.rs_vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "redshit gatway id"
  }
}
resource "aws_route_table_association" "redshift_ra" {

  subnet_id      = aws_subnet.rs_subnet[0].id
  route_table_id = aws_route_table.redshift_rt.id
}
resource "aws_default_security_group" "redshift_sg" {
  vpc_id = aws_vpc.rs_vpc.id

  ingress {
    description = "redshift port"
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
    from_port   = 5439
    to_port     = 5439
  }
  tags = {
    Name        = "testd-redshift-security-group"
    Environment = "test"
  }
}
