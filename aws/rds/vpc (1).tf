locals {

  cidr_base = "172.1.0.0/12"
  cidr_fail = "10.254.0.0/16"


  vpc_max        = 16
  cidr_available = [for index, x in data.aws_vpcs.all : cidrsubnet(local.cidr_base, 4, "${index}") if length(x.ids) == 0]
}

#Check if self exists
data "aws_vpcs" "self" {

  tags = {
    Name = "new-vpc"
  }
}

#Get self data
data "aws_vpc" "self" {

  count = length(data.aws_vpcs.self.ids) > 0 ? 1 : 0
  id    = data.aws_vpcs.self.ids[0]
}

#Get all VPCs
data "aws_vpcs" "all" {

  count = local.vpc_max
  filter {
    name   = "cidr"
    values = [cidrsubnet(local.cidr_base, 4, count.index)]
  }
}

#Use self CIDR or look for unused CIDR
resource "aws_vpc" "new_vpc" {

  cidr_block = (length(data.aws_vpcs.self.ids) > 0 ? data.aws_vpc.self[0].cidr_block :
    length(local.cidr_available) > 0 ? local.cidr_available[0] :
  local.cidr_fail)
  tags = {
    Name = "new-vpc"
  }
}