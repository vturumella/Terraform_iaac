variable "project" { default = "indigo-altar-345111" }
variable "region" { default = "us-east1" }
variable "access" { default = "../../../indigo-altar-345111-b111820236b3.json" }
variable "image" { default = "debian-cloud/debian-11" }
variable "name" { default = "galaxy-project" }
variable "zone" { default = "data.google_compute_zones.available.names[count.index]" }