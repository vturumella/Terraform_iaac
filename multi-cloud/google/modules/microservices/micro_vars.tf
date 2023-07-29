variable "machine_type" { default = "e2-medium" }
variable "image" { default = "debian-cloud/debian-11" }
variable "subnet-self_link" { default = "module.vpc.subnet-self_link" }
variable "enable_autoscaling" { default = true }
variable "region" { default = "us-east1" }
variable "project" { default = "indigo-altar-345111" }
variable "vpc-name" { default = "module.vpc.vpc-vpc-name" }
variable "zones" { default = ["us-east1-b", "us-easr1-d", "us-east1-e"] }