variable "rg" {
  type    = string
  default = "us-east-1"
}
variable "ak" {
  type    = string
  default = "AKIAUXVOEN7YSZS7SZ2D"
}
variable "sk" {
  type    = string
  default = "xkFJ+4woyxG/Vsm/dioz7Y7Bh4FORj1xk7I+DORJ"
}
variable "identifier" {
  type    = string
  default = "mydb-rds"

}
variable "storage" {
  type    = string
  default = "10"

}
variable "engine" {
  type    = string
  default = "mysql"

}
variable "engine-version" {

  default = {
    mysql = "8.0"
  }
}
variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_name" {
  type    = string
  default = "myfirstdb"

}
variable "security_group" {
  default = "my-rds-sg"

}

variable "cidr_block" {
  type    = string
  default = "172.1.0.0/16"
}
variable "subnet_1_cidr" {
  type    = string
  default = "172.0.0.0/12"
}
variable "subnet_2_cidr" {
  type    = string
  default = "172.0.0.0/12"
}
variable "dns_supp" {
  type    = bool
  default = true
}

variable "sgcidr_block" {

  type    = string
  default = "0.0.0.0/0"

}
variable "dns_host" {
  type    = bool
  default = true

}
variable "az_1" {
  default     = "us-east-1c"
  description = "Your Az1, use AWS CLI to find your account specific"
}
variable "az_2" {
  default     = "us-east-1a"
  description = "Your Az1, use AWS CLI to find your account specific"
}
variable "region_num" {
  default = {
    us-east-1 = 1
    us-west-1 = 2
  }

}
variable "az_num" {
  default = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
  }

}