terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
}
provider "aws" {
  region     = var.rg
  access_key = var.ak
  secret_key = var.sk
}
