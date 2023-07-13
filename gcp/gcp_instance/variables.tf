variable "region" {
  type    = string
  default = "us-east1"
  /* description = "(optional) describe your variable" */
}
variable "zone" {
  type    = string
  default = "us-east1-b"
  /* description = "(optional) describe your variable" */
}
variable "project" {
  type        = string
  default     = "root-welder-383716"
  description = "(optional) describe your variable"
}

variable "access" {
  type        = string
  default     = "../root-welder-383716-44986d2d374d.json"
  description = "(optional) describe your variable"
}
variable "cidr" {
  type = string
  default = "0.2.0.0/16"
  description = "(optional) describe your variable"
}
