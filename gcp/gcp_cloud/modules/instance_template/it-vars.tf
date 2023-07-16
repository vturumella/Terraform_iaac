variable "region" {
  default = "us-east1"
}
variable "project" {
  default = "root-welder-383716"

}
variable "access" {
  default = "~/terraform/gcp/root-welder-383716-da9dc216f477.json"
    
}
variable "vpc-name" {  default = "module.vpc.xcloud-vpc"}
variable "subnet-name" {  default = "module.vpc.xcloud-subnet"}
variable "webserver_template" { default = "module.instance_template.ws-instance_template"}
variable zones { default = ["us-east1-a", "us-east1-b"] }
variable "subnetwork" {
    default = "google_compute_subnetwork.xcloud-subnet"
  
}
variable "enable_autoscaling" {
    type = bool
    default = true
  
}
variable "name" { default = "xcloud-project" }
variable "image" {
  default = "google_compute_image.xcloud_image"
  
}