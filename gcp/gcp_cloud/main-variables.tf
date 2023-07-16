variable "project" {default = " root-welder-383716"}
variable "access" {default = "../../root-welder-383716-da9dc216f477.json"}
variable "region" { default = "us-east1" }
variable "zones" { default = ["us-east1-a", "us-east1-b"] }
variable "env" { default = "dev" }
variable "network_name" { default = "xcloud network" }
variable "image" { default = "ubuntu-os-cloud/ubuntu-1804-lts" }
variable "appserver_count" { default = 1 }
variable "webserver_count" { default = 2 }
variable "app_image" { default = "centos-7-v20170918" }
variable "instance_type" { default = "f1-micro" }
variable "no_of_db_instances" { default = 1 }
# variable create_default_vpc{ default = true }
variable "enable_autoscaling" { default = true }
variable "db_user" {default = "admin"}
variable "db_password" {default = "admin"}
variable "name" { default = "xcloud-project" }
variable "vpc-name" {  default = "module.vpc.xcloud-vpc"}
variable "subnet-name" {  default = "module.vpc.xcloud-subnet"}
variable "instance_template" { default = "module.instance_template.ws-instance_template"}