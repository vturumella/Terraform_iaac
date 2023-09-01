variable "vpc_name" { default = "module.network.vpc_name/self_link"}
variable "subnet_name" { default = "module.network.subnet_name.self_link"}
variable "image" { default = "debian-cloud/debian-11"}
variable "machine_type" { default = "e2-medium" }
variable "enable_autoscaling" { default = true }