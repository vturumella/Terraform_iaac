variable "dns_support" { default = true }
variable "dns_host" { default = true }
variable "access" { default = "AKIAULKNSSKSTYIJOEHU" }
variable "secret_key" { default = "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" }
variable "region" { default = "us-east-1" }
variable "project" { default = "xcloud-multicloud" }
variable "cidr_block" { default = ["0.0.0.0/0"] }
data "aws_availability_zones" "available" {}
variable "cidr_vpc" { default =  "10.20.0.0/16"}