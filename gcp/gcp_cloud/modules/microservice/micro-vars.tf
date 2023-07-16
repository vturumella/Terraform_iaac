variable zones { default = ["us-east1-a", "us-east1-b"] }
variable "image" { default = "ubuntu-os-cloud/ubuntu-2204-lts" }
variable "instance_type" { default = "f1-micro" }
variable "vpc-name" {  default = "module.vpc.xcloud-vpc"}
variable "subnet-name" {  default = "module.vpc.xcloud-subnet"}

