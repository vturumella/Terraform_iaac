variable "access" { default = "AKIAULKNSSKSTYIJOEHU" }
variable "secret_key" { default = "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" }
variable "region" { default = "us-east-1" }
variable "name" { default = "project-x" }
variable "subnet_id" { default = "module.vpc.subnet_id" }
variable "subnet1_id" { default = "module.vpc.subnet1_id" }
variable "instance" { default = "module.instance.xcloud_web" }
variable "security_sg" { default = "module.network.security_sg_id" }
variable "image_id" { default = "ami-05548f9cecf47b442" }
data "aws_availability_zones" "available" {
  state = "available"
}