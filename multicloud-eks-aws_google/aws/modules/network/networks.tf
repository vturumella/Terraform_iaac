resource "aws_vpc" "stratos-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.dns_host
  enable_dns_support   = var.dns_support
  tags = {
    Tier = "public"
  }
}
resource "aws_subnet" "stratos-subnet" {
  vpc_id            = aws_vpc.stratos-vpc.id
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.20.${10 + count.index}.0/24"


  tags = {
    tier = "public"
  }
}
resource "aws_subnet" "stratos-subnet1" {
  vpc_id            = aws_vpc.stratos-vpc.id
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.20.${20 + count.index}.0/24"

  tags = {
    Name = "Main"
  }
}
resource "aws_security_group" "stratos-sg" {
  name        = "${var.name}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.stratos-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_eip" "stratos-eip" {
  domain = "vpc"
}
resource "aws_internet_gateway" "stratos-gw" {
  vpc_id = aws_vpc.stratos-vpc.id
}
resource "aws_nat_gateway" "stratos-nat" {
  allocation_id = aws_eip.stratos-eip.id
  subnet_id     = aws_subnet.stratos-subnet[0].id

  tags = {
    Name = "gw NAT"
  }
}
resource "aws_route_table_association" "stratos-ra" {
  subnet_id      = aws_subnet.stratos-subnet[0].id
  route_table_id = aws_route_table.stratos-rt.id
}
resource "aws_route_table" "stratos-rt" {
  vpc_id = aws_vpc.stratos-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stratos-gw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_networkfirewall_firewall" "stratos-firewall" {
  name                = "${var.name}-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.stratos-firewall-policy.arn
  vpc_id              = aws_vpc.stratos-vpc.id
  subnet_mapping {
    subnet_id = aws_subnet.stratos-subnet[0].id
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}
resource "aws_networkfirewall_firewall_policy" "stratos-firewall-policy" {
  name = "${var.name}-firewall-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:drop"]
    # stateless_rule_group_reference {
    #   priority     = 1
    #   resource_arn = "arn:aws:network-firewall:var.rebion:aws-managed:stateless-rulegroup/stratos-project-rule-group"
    # }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}
resource "aws_networkfirewall_rule_group" "stratos-rule-group" {
  capacity = 100
  name     = "${var.name}-rule-group"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["HTTP_HOST"]
        targets              = ["test.example.com"]
      }
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}