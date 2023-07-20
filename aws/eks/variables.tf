variable "rg" {
  type    = string
  default = "us-east-1"
}
variable "ak" {
  type    = string
  default = "AKIAUXVOEN7Y5FGPHI3X"
}
variable "sk" {
  type    = string
  default = "LzL1pf/t+eXPScoa0jsyMjOcdPk5AQh/7XBgnBoy"
}

variable "cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "dns_supp" {
  type    = bool
  default = true
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "dns_host" {
  type    = bool
  default = true
}
variable "az_zone_cnt" {
  type    = number
  default = 2
}
