variable "location" { default = "us" }
variable "region" { default = "us-central1-c" }
variable "vpc_name" { default = "module.network.vpc_name"}
variable "private_subnet" { default = "module.network.private_subnet.self_link"}

