variable "region" { default = "us-east1" }
variable "zone" { default = ["us-east1-b", "us-easr1-d", "us-east1-e"] }
# variable "access" { default = file("~/indigo-altar-345111-b111820236b3.json") }
variable "vpc_cidr" { default = "10.2.0.0/16" }
variable "project" { default = "indigo-altar-345111" }