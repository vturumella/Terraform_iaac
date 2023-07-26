variable "access" { default = "AKIA2AUBABPJN4SY7DVA" }
variable "secret_key" { default = "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" }
variable "region" { default = "us-east-1" }
variable "name" { default = "xcloud-multicloud" }
# variable "vpc_id" {}
variable "subnet_id" { default = "module.vpc.subnet-name" }
variable "instance" { default = "module.instance.xcloud_web" }
variable "security_sg" { default = "module.network.security_sg_id" }
variable "image_id" { default = "ami-05548f9cecf47b442" }
variable "azn" { default = ["us-east-1a","us-east-1b","us-east-1d"]}
variable "create_default_vpc" { default = true }