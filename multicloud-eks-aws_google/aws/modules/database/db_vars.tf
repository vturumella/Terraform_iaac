variable "region" { default = "us-east-1" }
variable "access" { default = "AKIAULKNSSKSTYIJOEHU" }
variable "secret_key" { default = "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" }
variable "zone_cnt" { default = 2 }
data "aws_availability_zones" "available" {}
variable "vpc_cidr" { default = "10.20.0.0/16" }
variable "cidr_block" { default = "0.0.0.0/0" }
variable "vpc_id" { default = "aws_vpc.stratos-vpc.id" }
variable "name" { default = "stratos-project" }
variable "azn" { default = ["us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"] }
variable "instance_id" { default = "module.lb.instance_id" }
variable "subnet_public" { default = "module.network.subnet_public" }
variable "subnet_private" { default = "module.network.subnet_private" }
variable "role_arn" { default = "module.eks.role_arn"}