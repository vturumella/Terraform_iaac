variable "name" { default = "xcloud-project" }
variable "project" {default = "root-welder-383716"}
variable "access" { default = "~/terraform/gcp/root-welder-383716-da9dc216f477.json" }
variable "region" { default = "us-east1" }
variable "zones" { default = ["us-east1-a", "us-east1-b"] }
variable "instance_template" { default = "module.instance_template.ws-instance_template"}
variable "webserver_count" { default = 2 }